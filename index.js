export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const hostname = url.hostname;

    // Handle API requests for likes
    if (url.pathname.startsWith("/api/likes/")) {
      return handleLikesAPI(request, env, url);
    }

    // Handle media requests from R2
    if (url.pathname.startsWith("/media/")) {
      return handleR2Media(request, env, url);
    }

    // Determine asset path
    let assetPath;
    if (url.pathname === "/") {
      assetPath = "/index.html";
    } else if (!url.pathname.includes(".") && !url.pathname.endsWith("/")) {
      assetPath = url.pathname + ".html";
    } else {
      assetPath = url.pathname;
    }

    try {
      // Try to get the asset using the static assets binding
      const asset = await env.ASSETS.fetch(new URL(assetPath, request.url));

      if (asset.status === 404) {
        // If still not found, serve 404
        return new Response("Page not found", { status: 404 });
      }

      return addSecurityHeaders(asset);
    } catch (error) {
      console.error("Asset fetch error:", error);
      return new Response("Internal server error", { status: 500 });
    }
  },
};

async function handleLikesAPI(request, env, url) {
  // Get the origin from the request
  const origin = request.headers.get("Origin");

  // Define allowed origins
  const allowedOrigins = [
    "https://maclong.uk",
    "https://www.maclong.uk",
    "http://localhost:8787", // For development
    "http://127.0.0.1:8787", // For development
  ];

  // Determine if origin is allowed
  const allowOrigin = allowedOrigins.includes(origin) ? origin : "null";

  const corsHeaders = {
    "Access-Control-Allow-Origin": allowOrigin,
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
  };

  // Handle CORS preflight
  if (request.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  const pathParts = url.pathname.split("/");
  const postSlug = pathParts[3]; // /api/likes/{postSlug}

  // Input validation
  if (!postSlug) {
    return new Response("Post slug required", {
      status: 400,
      headers: corsHeaders,
    });
  }

  // Validate post slug format (alphanumeric, hyphens, underscores only)
  if (!/^[a-zA-Z0-9_-]+$/.test(postSlug) || postSlug.length > 100) {
    return new Response("Invalid post slug format", {
      status: 400,
      headers: corsHeaders,
    });
  }

  // Simple rate limiting using IP address
  const clientIP =
    request.headers.get("CF-Connecting-IP") ||
    request.headers.get("X-Forwarded-For") ||
    "unknown";
  const rateLimitKey = `rate:${clientIP}`;

  // Check rate limit for POST requests (like/unlike actions)
  if (request.method === "POST") {
    const rateLimitCount = parseInt(
      (await env.LIKES_KV.get(rateLimitKey)) || "0",
    );
    if (rateLimitCount >= 10) {
      // Max 10 requests per minute
      return new Response("Rate limit exceeded", {
        status: 429,
        headers: corsHeaders,
      });
    }

    // Increment rate limit counter with 60 second expiry
    await env.LIKES_KV.put(rateLimitKey, (rateLimitCount + 1).toString(), {
      expirationTtl: 60,
    });
  }

  const kvKey = `likes:${postSlug}`;

  try {
    if (request.method === "GET") {
      // Get like count for a post
      const likes = await env.LIKES_KV.get(kvKey);
      return new Response(
        JSON.stringify({
          postSlug,
          likes: parseInt(likes || "0"),
        }),
        {
          headers: {
            "Content-Type": "application/json",
            ...corsHeaders,
          },
        },
      );
    }

    if (request.method === "POST") {
      // Validate Content-Type
      const contentType = request.headers.get("Content-Type");
      if (!contentType || !contentType.includes("application/json")) {
        return new Response("Content-Type must be application/json", {
          status: 400,
          headers: corsHeaders,
        });
      }

      let requestData;
      try {
        requestData = await request.json();
      } catch {
        return new Response("Invalid JSON body", {
          status: 400,
          headers: corsHeaders,
        });
      }

      // Validate action parameter
      const { action } = requestData;
      if (
        !action ||
        typeof action !== "string" ||
        !["like", "unlike"].includes(action)
      ) {
        return new Response("Invalid action. Must be 'like' or 'unlike'", {
          status: 400,
          headers: corsHeaders,
        });
      }

      // Get current count
      const currentLikes = parseInt((await env.LIKES_KV.get(kvKey)) || "0");

      // Update count
      let newLikes;
      if (action === "like") {
        newLikes = currentLikes + 1;
      } else {
        newLikes = Math.max(0, currentLikes - 1);
      }

      // Store updated count
      await env.LIKES_KV.put(kvKey, newLikes.toString());

      return new Response(
        JSON.stringify({
          postSlug,
          likes: newLikes,
          action,
        }),
        {
          headers: {
            "Content-Type": "application/json",
            ...corsHeaders,
          },
        },
      );
    }

    return new Response("Method not allowed", {
      status: 405,
      headers: corsHeaders,
    });
  } catch (error) {
    console.error("Likes API error:", error);
    return new Response("Internal server error", {
      status: 500,
      headers: corsHeaders,
    });
  }
}

async function handleR2Media(request, env, url) {
  try {
    // Extract the path after /media/
    // e.g., /media/photos/AlbumName/photo.jpg -> photos/AlbumName/photo.jpg
    const encodedPath = url.pathname.substring(7); // Remove "/media/"
    const objectKey = decodeURIComponent(encodedPath);

    console.log('R2 Request:', {
      originalPath: url.pathname,
      encodedPath: encodedPath,
      objectKey: objectKey
    });

    // Get object from R2
    const object = await env.PORTFOLIO_MEDIA.get(objectKey);

    if (object === null) {
      console.log('R2 object not found:', objectKey);
      return new Response(`Media not found: ${objectKey}`, { status: 404 });
    }

    console.log('R2 object found:', objectKey);

    // Return the object with appropriate headers
    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set("Cache-Control", "public, max-age=31536000, immutable");

    return new Response(object.body, {
      headers,
    });
  } catch (error) {
    console.error("R2 media error:", error);
    return new Response("Internal server error", { status: 500 });
  }
}

function addSecurityHeaders(response) {
  const newResponse = new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: response.headers,
  });

  // Add security headers
  newResponse.headers.set("X-Content-Type-Options", "nosniff");
  newResponse.headers.set("X-Frame-Options", "DENY");
  newResponse.headers.set("X-XSS-Protection", "1; mode=block");
  newResponse.headers.set("Referrer-Policy", "strict-origin-when-cross-origin");

  // Enhanced Content Security Policy with stricter controls
  const cspDirectives = [
    "default-src 'self'",
    // Remove unsafe-inline and unsafe-eval for better security
    "script-src 'self' https://cdn.jsdelivr.net https://unpkg.com",
    "style-src 'self' https://cdn.jsdelivr.net",
    "img-src 'self' data: https:",
    "font-src 'self' data:",
    "connect-src 'self'",
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "upgrade-insecure-requests"
  ];
  newResponse.headers.set("Content-Security-Policy", cspDirectives.join("; "));

  return newResponse;
}