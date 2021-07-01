require_relative 'time_util'

class App
  START_SYMBOL_OF_QUERY_VALUE = 7

  def initialize
    @time_util = TimeUtil.new
  end

  def call(env)
    route(env)
  end

  private

  def route(env)
    req = Rack::Request.new(env)
    return time(req.query_string) if req.get?

    Rack::Response.new(["Use GET request for '/time'."], 404, {}).finish
  end

  def time(query)
    if query.empty? ||
      !query.start_with?("format=") ||
      query[START_SYMBOL_OF_QUERY_VALUE..].empty?
      return [400, {}, ["Time format is absent"]]
    end

    query_value = query[START_SYMBOL_OF_QUERY_VALUE..]
    time_units = query_value.split(/%../)
    error_response = @time_util.validate_time_units(time_units)
    return [400, {}, [error_response]] if error_response

    body = @time_util.formatted_time(query_value)
    [200, {}, [body]]
  end
end
