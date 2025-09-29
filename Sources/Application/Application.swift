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
      
      // Dynamic article routes - error handling moved to ArticlesService
      let articles = try ArticlesService.fetchAllArticles()
      for article in articles {
        DynamicArticle(article: article)
      }
    }
  }

  var baseURL: String? {
    "https://maclong.uk"
  }

  var head: String? {
    """
    <!-- Resource preloading for performance optimization -->
    <link rel="preload" href="https://unpkg.com/@tailwindcss/browser@4" as="script">
    <link rel="preload" href="https://unpkg.com/lucide@latest" as="script">
    <link rel="dns-prefetch" href="//unpkg.com">
    <link rel="preload" href="/public/js/theme.js" as="script">
    <link rel="preload" href="/public/js/icons.js" as="script">
    
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
        
        /* Typography enhancements for prose content */
        .prose {
            @apply text-zinc-700 dark:text-zinc-300 leading-relaxed;
        }

        /* Paragraph spacing */
        .prose p {
            @apply mb-6 leading-relaxed;
        }

        /* Headings */
        .prose h1 {
            @apply text-3xl font-bold text-zinc-900 dark:text-zinc-100 mt-12 mb-6 leading-tight;
        }
        
        .prose h2 {
            @apply text-2xl font-bold text-zinc-900 dark:text-zinc-100 mt-10 mb-4 leading-tight;
        }
        
        .prose h3 {
            @apply text-xl font-semibold text-zinc-900 dark:text-zinc-100 mt-8 mb-3 leading-snug;
        }
        
        .prose h4 {
            @apply text-lg font-semibold text-zinc-900 dark:text-zinc-100 mt-6 mb-2;
        }

        /* Lists */
        .prose ul {
            @apply mb-6 pl-6;
        }
        
        .prose ol {
            @apply mb-6 pl-6;
        }
        
        .prose li {
            @apply mb-2 leading-relaxed;
        }
        
        .prose ul > li {
            @apply relative;
        }
        
        .prose ul > li::before {
            content: "•";
            @apply absolute -left-4 text-teal-600 dark:text-teal-400 font-medium;
        }

        /* Links */
        .prose a {
            @apply text-teal-600 dark:text-teal-400 underline decoration-teal-600/30 underline-offset-2 transition-colors;
        }
        
        .prose a:hover {
            @apply text-teal-700 dark:text-teal-300 decoration-teal-600/60;
        }

        /* Blockquotes */
        .prose blockquote {
            @apply border-l-4 border-teal-500 pl-6 py-4 my-6 italic text-zinc-600 dark:text-zinc-400 bg-zinc-50 dark:bg-zinc-800/50 rounded-r;
        }
        
        .prose blockquote p {
            @apply mb-3 last:mb-0;
        }
        
        /* Blockquote attribution styling */
        .prose blockquote cite,
        .prose blockquote footer {
            @apply not-italic text-sm text-zinc-500 dark:text-zinc-500 mt-3 block;
        }
        
        .prose blockquote cite::before,
        .prose blockquote footer::before {
            content: "— ";
        }
        
        /* Attribution styling for marked elements */
        .prose blockquote p.attribution {
            @apply not-italic text-sm text-zinc-500 dark:text-zinc-500 mt-3;
        }

        /* Code block styling */
        .prose pre {
            @apply bg-zinc-900 dark:bg-zinc-800 text-zinc-100 text-xs p-4 rounded-lg my-6 overflow-x-auto;
            border: 1px solid theme(colors.zinc.700);
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }
        
        .prose code:not(pre code) {
            @apply bg-zinc-100 dark:bg-zinc-800 text-zinc-900 dark:text-zinc-100 px-1.5 py-0.5 rounded text-sm font-mono;
        }

        /* Tables */
        .prose table {
            @apply w-full my-6 border-collapse;
        }
        
        .prose th {
            @apply bg-zinc-50 dark:bg-zinc-800 font-semibold text-left px-4 py-3 border-b border-zinc-200 dark:border-zinc-700;
        }
        
        .prose td {
            @apply px-4 py-3 border-b border-zinc-100 dark:border-zinc-800;
        }

        /* Horizontal rules */
        .prose hr {
            @apply my-8 border-t-2 border-zinc-200 dark:border-zinc-700;
        }

        /* Strong and emphasis */
        .prose strong {
            @apply font-semibold text-zinc-900 dark:text-zinc-100;
        }
        
        .prose em {
            @apply italic text-zinc-600 dark:text-zinc-400;
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
      Script(src: "/public/js/theme.js", placement: .head),
      Script(src: "/public/js/icons.js", placement: .body),
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
    let publicDir = outputDir.appendingPathComponent("dist/public")
    let jsDir = publicDir.appendingPathComponent("js")
    
    // Ensure directories exist
    try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
    try FileManager.default.createDirectory(at: jsDir, withIntermediateDirectories: true)
    
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
      """
    
    // Write JavaScript files for CSP compliance
    let themeJSContent = """
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

      // Mobile menu functions (class-based for smooth transitions)
      window.toggleSlideMenu = function(containerId) {
        const container = document.getElementById(containerId);
        const overlay = document.querySelector('#mobile-menu-overlay');
        if (!container || !overlay) return;

        const isOpen = container.dataset.mobileMenuOpen === 'true';
        if (isOpen) {
          // Close menu: translate to the right and then hide
          overlay.classList.remove('translate-x-0');
          overlay.classList.add('translate-x-full');
          setTimeout(() => {
            overlay.classList.add('hidden');
          }, 300); // match duration-300
          container.dataset.mobileMenuOpen = 'false';
          overlay.dataset.mobileMenu = 'closed';
        } else {
          // Open menu: show, then translate to 0 on next frame
          overlay.classList.remove('hidden');
          // Force reflow so the transition runs when classes change
          overlay.getBoundingClientRect();
          overlay.classList.remove('translate-x-full');
          overlay.classList.add('translate-x-0');
          container.dataset.mobileMenuOpen = 'true';
          overlay.dataset.mobileMenu = 'open';
        }
      };

      window.closeSlideMenu = function(containerId) {
        const container = document.getElementById(containerId);
        const overlay = document.querySelector('#mobile-menu-overlay');
        if (!container || !overlay) return;

        overlay.classList.remove('translate-x-0');
        overlay.classList.add('translate-x-full');
        setTimeout(() => {
          overlay.classList.add('hidden');
        }, 300);
        container.dataset.mobileMenuOpen = 'false';
        overlay.dataset.mobileMenu = 'closed';
      };

      // Close menu when clicking on mobile menu links
      document.addEventListener('click', function(e) {
        if (e.target.closest('[data-mobile-menu-link]')) {
          window.closeSlideMenu('mobile-menu-container');
        }
      });

      // Close menu button functionality
      document.addEventListener('click', function(e) {
        if (e.target.closest('[data-slide-menu-close]')) {
          window.closeSlideMenu('mobile-menu-container');
        }
      });

      // Open menu button functionality (delegated listener)
      document.addEventListener('click', function(e) {
        if (e.target.closest('#mobile-menu-button')) {
          e.preventDefault();
          window.toggleSlideMenu('mobile-menu-container');
        }
      });
      """
    
    let iconsJSContent = """
      // Initialize Lucide icons
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
      """
    
    let themeJSURL = jsDir.appendingPathComponent("theme.js")
    let iconsJSURL = jsDir.appendingPathComponent("icons.js")
    
    try themeJSContent.write(to: themeJSURL, atomically: true, encoding: .utf8)
    try iconsJSContent.write(to: iconsJSURL, atomically: true, encoding: .utf8)
    print("✓ JavaScript files written for CSP compliance")
    
    let indexJSURL = outputDir.appendingPathComponent("index.js")
    try indexJSContent.write(to: indexJSURL, atomically: true, encoding: .utf8)
    print("✓ index.js written to output directory")
  }
}
