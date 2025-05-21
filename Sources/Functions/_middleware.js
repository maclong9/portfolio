export async function onRequest(context) {
  try {
    const { request, env } = context;
    const url = new URL(request.url);
    const { hostname, pathname } = url;

    // Domain detection
    const isStaticDomain =
      hostname === "static.maclong.uk" || hostname.includes("static.localhost");
    const isNotesDomain =
      hostname === "notes.maclong.uk" || hostname.includes("notes.localhost");
    const isRootDomain = hostname === "maclong.uk";
    const isProxyLoop = request.headers.get("CF-Worker") === "true";

    // Static subdomain handler
    if (isStaticDomain) {
      const key = pathname.startsWith("/") ? pathname.slice(1) : pathname;
      const object = await env.GENERAL_STATIC.get(key);
      if (!object) return new Response("File not found", { status: 404 });

      return new Response(object.body, {
        headers: {
          "Content-Type": getContentType(key),
          "Cache-Control": "public, max-age=31536000",
        },
      });
    }

    // Notes subdomain handler
    if (isNotesDomain) {
      const redirects = { "/projects": "https://maclong.uk/projects" };
      for (const [prefix, target] of Object.entries(redirects)) {
        if (pathname === prefix || pathname.startsWith(prefix + "/")) {
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
          return await proxyRequest(
            targetBase + pathname.slice(prefix.length),
            request,
          );
        }
      }

      return new Response("Not Found", { status: 404 });
    }

    // Root domain handler
    if (isRootDomain) {
      // Prevent proxy loops by directly serving content
      if (isProxyLoop) {
        return context.next();
      }

      // For the root domain, we'll use the context.next() to serve from Pages directly
      // This prevents proxy loops
      return context.next();
    }

    // Final localhost fallback
    if (isLocalhost) return context.next();

    return new Response(`Unsupported domain: ${hostname}`, { status: 400 });
  } catch (err) {
    return new Response(`Server error: ${err.message}\n${err.stack}`, {
      status: 500,
    });
  }
}

// Helper for proxy requests
async function proxyRequest(targetUrl, originalRequest) {
  const headers = new Headers();
  headers.set(
    "User-Agent",
    originalRequest.headers.get("User-Agent") || "Cloudflare-Worker",
  );

  try {
    const response = await fetch(targetUrl, {
      headers,
      redirect: "follow",
    });

    if (!response.ok) {
      return new Response(`Proxy error: ${targetUrl} (${response.status})`, {
        status: response.status,
      });
    }

    const responseBody = await response.text();
    return new Response(responseBody, {
      status: response.status,
      headers: {
        "Content-Type": response.headers.get("Content-Type") || "text/html",
      },
    });
  } catch (error) {
    return new Response(`Failed to fetch: ${error.message}`, { status: 502 });
  }
}

function getContentType(key) {
  if (key.endsWith(".css")) return "text/css";
  if (key.endsWith(".js")) return "application/javascript";
  if (key.endsWith(".json")) return "application/json";
  if (key.endsWith(".png")) return "image/png";
  if (key.endsWith(".jpg") || key.endsWith(".jpeg")) return "image/jpeg";
  if (key.endsWith(".svg")) return "image/svg+xml";
  if (key.endsWith(".woff2")) return "font/woff2";
  return "application/octet-stream";
}
