import Foundation
import WebUI

@main
struct Application: Website {
  var metadata: Metadata {
    Metadata(
      site: "Mac Long",
      title: "Software Engineer",
      titleSeparator: " | ",
      description:
        "Swift, TypeScript, React and TailwindCSS developer crafting clean code and efficient forward-thinking solutions",
      image: "/public/og.jpg",
      author: "Mac Long",
      keywords: [
        "software engineer", "swift developer", "react developer", "typescript", "tailwindcss",
        "frontend development", "skateboarding", "punk rock", "web development", "iOS development",
      ],
      locale: .en,
      type: .website,
      favicons: [
        Favicon(
          "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='48' height='48' viewBox='0 0 16 16'><text x='0' y='14'>👨‍💻</text></svg>"
        )
      ],
      structuredData: .person(
        name: "Mac Long",
        givenName: "Mac",
        familyName: "Long",
        image: "https://avatars.githubusercontent.com/u/115668288?v=4",
        jobTitle: "Software Engineer",
        email: "hello@maclong.uk",
        webAddress: "https://maclong.uk",
        birthDate: ISO8601DateFormatter().date(from: "1995-10-19"),
        sameAs: [
          "https://github.com/maclong9",
          "https://orcid.org/0009-0002-4180-3822",
        ]
      )
    )
  }

  @WebsiteRouteBuilder
  var routes: [any Document] {
    get throws {
      Home()
      Posts()
      Tools()
      BarreScales()
      SchengenTracker()
      Missing()
    }
  }

  var baseURL: String? {
    "https://maclong.uk"
  }

  var head: String? {
    """
    <style type="text/tailwindcss">
        @custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
        
        /* Hero animations */
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes avatarFadeIn {
            from {
                opacity: 0;
                transform: scale(0.8);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        /* Progressive Reveal for Cards */
        .reveal-card {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }
        
        .reveal-card.in-view {
            opacity: 1;
            transform: translateY(0);
        }
        
        .reveal-card:nth-child(1) { transition-delay: 0.1s; }
        .reveal-card:nth-child(2) { transition-delay: 0.2s; }
        .reveal-card:nth-child(3) { transition-delay: 0.3s; }
        .reveal-card:nth-child(4) { transition-delay: 0.4s; }
        .reveal-card:nth-child(5) { transition-delay: 0.5s; }
        .reveal-card:nth-child(6) { transition-delay: 0.6s; }
        
        /* Hero element animations */
        .hero-avatar {
            animation: avatarFadeIn 0.8s ease-out;
        }
        
        .hero-name {
            animation: slideUp 0.6s ease-out 0.1s both;
        }
        
        .hero-description {
            animation: slideUp 0.6s ease-out 0.3s both;
        }
        
        /* Accessibility: Hide animations on reduced motion preference */
        @media (prefers-reduced-motion: reduce) {
            .reveal-card,
            .hero-avatar,
            .hero-name, 
            .hero-description {
                animation: none !important;
                transition: none !important;
                opacity: 1 !important;
                transform: none !important;
            }
        }
    </style>
    """
  }

  var scripts: [Script]? {
    [
      Script(
        placement: .head,
        content: {
          """
          // Prevent FOUC by setting theme immediately
          (function () {
            const savedTheme = localStorage.getItem('theme') || 'system';
            const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

            let actualTheme = 'light';
            if (savedTheme === 'dark') {
              actualTheme = 'dark';
            } else if (savedTheme === 'system') {
              actualTheme = systemPrefersDark ? 'dark' : 'light';
            }

            document.documentElement.setAttribute('data-theme', actualTheme);
          })();
          """
        }
      ),
      Script(placement: .body) { "lucide.createIcons();" },
    ]
  }

  static func main() async throws {
    do {
      let application = Application()
      try application.build(to: URL(filePath: ".output/dist"))

      // Write embedded configuration files to output directory
      try writeConfigurationFiles()

      print("✓ Application built successfully.")
    } catch {
      print("⨉ Failed to build application: \(error)")
    }
  }

  private static func writeConfigurationFiles() throws {
    let outputDir = URL(filePath: ".output")
    
    // Ensure output directory exists
    try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    
    // Write wrangler.toml
    let wranglerContent = """
      compatibility_date = "2025-08-16"
      main = "index.js"
      name = "portfolio"

      [assets]
      binding = "ASSETS"
      directory = "dist/"
      not_found_handling = "404-page"

      [[kv_namespaces]]
      binding = "LIKES_KV"
      id = "88a8b09d81654afca89d0c740f7977b6"

      [observability.logs]
      enabled = true

      [placement]
      mode = "smart"

      [[routes]]
      pattern = "maclong.uk"
      custom_domain = true

      [[routes]]
      pattern = "tools.maclong.uk"
      custom_domain = true
      """
    
    let wranglerURL = outputDir.appendingPathComponent("wrangler.toml")
    try wranglerContent.write(to: wranglerURL, atomically: true, encoding: .utf8)
    print("✓ wrangler.toml written to output directory")
    
    // Write index.js
    let indexJSContent = """
      export default {
        async fetch(request, env) {
          const url = new URL(request.url);
          const hostname = url.hostname;

          // Handle API requests for likes
          if (url.pathname.startsWith("/api/likes/")) {
            return handleLikesAPI(request, env, url);
          }

          // Determine asset path based on hostname
          let assetPath;
          if (hostname === "tools.maclong.uk") {
            // For tools subdomain, serve from /tools directory
            if (url.pathname === "/") {
              assetPath = "/tools.html";
            } else if (!url.pathname.includes(".") && !url.pathname.endsWith("/")) {
              assetPath = url.pathname + ".html";
            } else {
              assetPath = url.pathname;
            }
          } else {
            // For main domain (maclong.uk), serve from root
            if (url.pathname === "/") {
              assetPath = "/index.html";
            } else if (!url.pathname.includes(".") && !url.pathname.endsWith("/")) {
              assetPath = url.pathname + ".html";
            } else {
              assetPath = url.pathname;
            }
          }

          try {
            // Try to get the asset using the static assets binding
            const asset = await env.ASSETS.fetch(new URL(assetPath, request.url));

            if (asset.status === 404) {
              // For tools subdomain, if root path fails, try /tools/index.html
              if (hostname === "tools.maclong.uk" && url.pathname === "/") {
                const toolsFallback = await env.ASSETS.fetch(new URL("/tools/index.html", request.url));
                if (toolsFallback.status !== 404) {
                  return addSecurityHeaders(toolsFallback);
                }
              }

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
          "https://tools.maclong.uk",
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

        // Content Security Policy for enhanced security
        const cspDirectives = [
          "default-src 'self'",
          "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://unpkg.com 'unsafe-eval'",
          "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",
          "img-src 'self' data: https:",
          "font-src 'self' data:",
          "connect-src 'self'",
          "frame-ancestors 'none'",
          "base-uri 'self'",
          "form-action 'self'",
        ];
        newResponse.headers.set("Content-Security-Policy", cspDirectives.join("; "));

        return newResponse;
      }
      """
    
    let indexJSURL = outputDir.appendingPathComponent("index.js")
    try indexJSContent.write(to: indexJSURL, atomically: true, encoding: .utf8)
    print("✓ index.js written to output directory")
  }
}
