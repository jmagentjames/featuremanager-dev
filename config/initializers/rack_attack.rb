# config/initializers/rack_attack.rb
#
# Rate limiting for contact form abuse prevention (ADR-0003)
# https://github.com/rack/rack-attack

class Rack::Attack

  # Disable Rack::Attack in test environment
  Rack::Attack.enabled = !Rails.env.test?

  # --- Throttle: contact form submissions ---

  # Allow max 5 POST /messages per IP per 10 minutes.
  # After that, IP gets a 429 Too Many Requests.
  throttle("messages/ip/10min", limit: 5, period: 10.minutes) do |req|
    req.ip if req.post? && req.path == "/messages"
  end

  # --- Safelist ---

  # Localhost is always allowed (dev, OVO)
  safelist("localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  # --- Custom response ---

  # Called when a request is throttled.
  # Returns a 429 response with Retry-After header.
  self.throttled_responder = lambda do |req|
    match_data = req.env["rack.attack.match_data"]
    retry_after = match_data[:period] - (Time.now.to_i % match_data[:period])

    Rails.logger.warn {
      "[Rack::Attack] Throttled IP: #{req.ip} — #{req.method} #{req.path} — retry after #{retry_after}s"
    }

    [
      429,
      {
        "Content-Type" => "text/html",
        "Retry-After" => retry_after.to_s,
        "X-RateLimit-Limit" => match_data[:limit].to_s,
        "X-RateLimit-Remaining" => "0",
        "X-RateLimit-Reset" => (Time.now + retry_after).to_i.to_s
      },
      [
        <<~HTML
          <!DOCTYPE html>
          <html lang="en">
            <head>
              <meta charset="utf-8">
              <title>Too Many Requests</title>
              <style>
                body { font-family: system-ui, sans-serif; text-align: center; padding: 4rem; background: #f9fafb; color: #111; }
                h1 { font-size: 2rem; margin-bottom: 0.5rem; }
                p { color: #6b7280; }
                a { color: #2563eb; }
              </style>
            </head>
            <body>
              <h1>Too Many Requests</h1>
              <p>You've submitted too many messages. Please try again later.</p>
              <p><a href="/">Return home</a></p>
            </body>
          </html>
        HTML
      ]
    ]
  end
end
