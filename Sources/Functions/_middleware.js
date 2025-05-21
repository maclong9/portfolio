export async function onRequest(context) {
  // Initialize metrics dataset (assumes ANALYTICS binding in wrangler.toml)
  const metrics = context.env.ANALYTICS || {
    writeDataPoint: () => {} // Fallback for local dev
  };
  
  // Start tracing span
  const trace = context.trace?.startSpan?.('request') || { end: () => {} };
  
  try {
    const { request, env } = context;
    const url = new URL(request.url);
    const { hostname, pathname } = url;

    // Log request details
    console.log({
      event: 'request_received',
      method: request.method,
      url: request.url,
      hostname,
      pathname,
      timestamp: new Date().toISOString()
    });

    // Record request metric
    metrics.writeDataPoint({
      blobs: [hostname, pathname, request.method],
      doubles: [1],
      indexes: [request.cf?.colo || 'unknown']
    });

    // Domain detection
    const isStaticDomain =
      hostname === "static.maclong.uk" || hostname.includes("static.localhost");
    const isNotesDomain =
      hostname === "notes.maclong.uk" || hostname.includes("notes.localhost");
    const isRootDomain = hostname === "maclong.uk";
    const isLocalhost = hostname.includes("localhost");

    // Static subdomain handler
    if (isStaticDomain) {
      const traceSpan = context.trace?.startSpan?.('static_file') || { end: () => {} };
      const key = pathname.startsWith("/") ? pathname.slice(1) : pathname;
      
      console.log({
        event: 'static_file_access',
        key,
        timestamp: new Date().toISOString()
      });

      const object = await env.GENERAL_STATIC.get(key);
      if (!object) {
        metrics.writeDataPoint({
          blobs: [hostname, pathname, 'static_404'],
          doubles: [1]
        });
        traceSpan.end?.();
        return new Response("File not found", { status: 404 });
      }

      metrics.writeDataPoint({
        blobs: [hostname, pathname, 'static_success'],
        doubles: [1]
      });

      traceSpan.end?.();
      return new Response(object.body, {
        headers: {
          "Content-Type": getContentType(key),
          "Cache-Control": "public, max-age=31536000",
          "X-Trace-Id": context.trace?.traceId || 'none'
        },
      });
    }

    // Notes subdomain handler
    if (isNotesDomain) {
      const traceSpan = context.trace?.startSpan?.('notes_handler') || { end: () => {} };
      
      const redirects = { "/projects": "https://maclong.uk/projects" };
      for (const [prefix, target] of Object.entries(redirects)) {
        if (pathname === prefix || pathname.startsWith(prefix + "/")) {
          console.log({
            event: 'redirect',
            from: pathname,
            to: target + pathname.slice(prefix.length),
            timestamp: new Date().toISOString()
          });
          
          metrics.writeDataPoint({
            blobs: [hostname, pathname, 'redirect'],
            doubles: [1]
          });

          traceSpan.end?.();
          return Response.redirect(target + pathname.slice(prefix.length), 302);
        }
      }

      const proxies = {
        "/comp-sci": "https://maclong9.github.io/comp-sci",
        "/math-notes": "https://maclong9.github.io/mathematics",
        "/": "https://maclong.uk/notes",
      };

      for (const [prefix, targetBase] of Object.entries(proxies)) {
        if (pathname === prefix || pathname.startsWith(prefix + "/")) {
          console.log({
            event: 'proxy_request',
            from: pathname,
            to: targetBase + pathname.slice(prefix.length),
            timestamp: new Date().toISOString()
          });

          const response = await proxyRequest(
            targetBase + pathname.slice(prefix.length),
            request,
            context.trace
          );

          metrics.writeDataPoint({
            blobs: [hostname, pathname, 'proxy'],
            doubles: [1]
          });

          traceSpan.end?.();
          return response;
        }
      }

      metrics.writeDataPoint({
        blobs: [hostname, pathname, 'notes_404'],
        doubles: [1]
      });

      traceSpan.end?.();
      return new Response("Not Found", { status: 404 });
    }

    // Root domain handler
    if (isRootDomain) {
      console.log({
        event: 'root_domain',
        hostname,
        timestamp: new Date().toISOString()
      });
      
      metrics.writeDataPoint({
        blobs: [hostname, pathname, 'root'],
        doubles: [1]
      });

      trace.end?.();
      return context.next();
    }

    // Final localhost fallback
    if (isLocalhost) {
      console.log({
        event: 'localhost_fallback',
        hostname,
        timestamp: new Date().toISOString()
      });
      
      metrics.writeDataPoint({
        blobs: [hostname, pathname, 'localhost'],
        doubles: [1]
      });

      trace.end?.();
      return context.next();
    }

    metrics.writeDataPoint({
      blobs: [hostname, pathname, 'unsupported_domain'],
      doubles: [1]
    });

    trace.end?.();
    return new Response(`Unsupported domain: ${hostname}`, { status: 400 });
  } catch (err) {
    console.error({
      event: 'error',
      message: err.message,
      stack: err.stack,
      timestamp: new Date().toISOString()
    });

    metrics.writeDataPoint({
      blobs: ['error', err.message],
      doubles: [1]
    });

    trace.end?.();
    return new Response(`Server error: ${err.message}\n${err.stack}`, {
      status: 500,
      headers: { 'X-Trace-Id': context.trace?.traceId || 'none' }
    });
  }
}

// Helper for proxy requests
async function proxyRequest(targetUrl, originalRequest, trace) {
  const traceSpan = trace?.startSpan?.('proxy_fetch') || { end: () => {} };
  
  const headers = new Headers();
  headers.set(
    "User-Agent",
    originalRequest.headers.get("User-Agent") || "Cloudflare-Worker",
  );
  headers.set('X-Trace-Id', trace?.traceId || 'none');

  try {
    const response = await fetch(targetUrl, {
      headers,
      redirect: "follow",
    });

    if (!response.ok) {
      console.error({
        event: 'proxy_error',
        url: targetUrl,
        status: response.status,
        timestamp: new Date().toISOString()
      });

      traceSpan.end?.();
      return new Response(`Proxy error: ${targetUrl} (${response.status})`, {
        status: response.status,
        headers: { 'X-Trace-Id': trace?.traceId || 'none' }
      });
    }

    const responseBody = await response.text();
    
    console.log({
      event: 'proxy_success',
      url: targetUrl,
      status: response.status,
      timestamp: new Date().toISOString()
    });

    traceSpan.end?.();
    return new Response(responseBody, {
      status: response.status,
      headers: {
        "Content-Type": response.headers.get("Content-Type") || "text/html",
        'X-Trace-Id': trace?.traceId || 'none'
      },
    });
  } catch (error) {
    console.error({
      event: 'proxy_failure',
      url: targetUrl,
      error: error.message,
      timestamp: new Date().toISOString()
    });

    traceSpan.end?.();
    return new Response(`Failed to fetch: ${error.message}`, { 
      status: 502,
      headers: { 'X-Trace-Id': trace?.traceId || 'none' }
    });
  }
}

function getContentType(key) {
  if (key.endsWith(".css")) return "text/css";
  if (key.endsWith(".js")) return "application/x-javascript";
  if (key.endsWith(".json")) return "application/json";
  if (key.endsWith(".png")) return "image/png";
  if (key.endsWith(".jpg") || key.endsWith(".jpeg")) return "image/jpeg";
  if (key.endsWith(".svg")) return "image/svg+xml";
  if (key.endsWith(".woff2")) return "font/woff2";
  return "application/octet-stream";
}
