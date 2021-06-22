class App
  START_SYMBOL_OF_QUERY_VALUE = 7
  AVAILABLE_TIME_UNITS =
    {
      "year" => "Y",
      "month" => "m",
      "day" => "d",
      "hour" => "H",
      "minute" => "M",
      "second" => "S",
    }.freeze

  def call(env)
    route(env)
  end

  private

  def route(env)
    if env["REQUEST_PATH"] == ("/time") && env["REQUEST_METHOD"] == "GET"
      return time(env["QUERY_STRING"])
    end

    [404, headers, ["oops"]]
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def time(query)
    if query.empty? ||
      !query.start_with?("format=") ||
      query[START_SYMBOL_OF_QUERY_VALUE..].empty?
      return [400, headers, ["Time format is absent"]]
    end

    value = query[START_SYMBOL_OF_QUERY_VALUE..]
    time_units = value.split("%2C")
    error_response = validate_time_units(time_units)
    return error_response if error_response

    formatted_time(time_units)
  end

  def validate_time_units(units)
    unknown_formats = []
    units.each do |unit|
      unknown_formats << unit unless AVAILABLE_TIME_UNITS.keys.include?(unit)
    end
    return if unknown_formats.empty?

    [400, headers, ["Unknown time format #{unknown_formats}"]]
  end

  def formatted_time(units)
    format = ruby_format_string(units)
    [200, headers, [Time.now.strftime(format)]]
  end

  def ruby_format_string(units)
    format = ""
    units.each do |unit|
      format << "%#{AVAILABLE_TIME_UNITS[unit]}-"
    end
    format
  end
end
