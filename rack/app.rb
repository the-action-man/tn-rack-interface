require_relative 'current_time'
require_relative 'headers'

class App
  def call(env)
    route(env)
  end

  private

  def route(env)
    req = Rack::Request.new(env)
    time = CurrentTime.new(req.query_string)

    return time.call if req.path == ("/time") && req.get?

    Rack::Response.new(["oops"], 404, headers).finish
  end

  def headers
    # { 'Content-Type' => 'text/plain' }
    Headers::HEADERS
  end
end
