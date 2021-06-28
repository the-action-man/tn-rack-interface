class CurrentTimeController
  START_SYMBOL_OF_QUERY_VALUE = 7.freeze
  AVAILABLE_TIME_UNITS =
    {
      "year" => "Y",
      "month" => "m",
      "day" => "d",
      "hour" => "H",
      "minute" => "M",
      "second" => "S",
    }.freeze

  def initialize(query)
    @query = query
  end

  def call
    time(query)
  end

  private


  def query
    @query
  end

  def time(query)
    if query.empty? ||
      !query.start_with?("format=") ||
      query[START_SYMBOL_OF_QUERY_VALUE..].empty?
      return [400, {}, ["Time format is absent"]]
    end

    query_value = query[START_SYMBOL_OF_QUERY_VALUE..]
    time_units = query_value.split(/%../)
    error_response = validate_time_units(time_units)
    return error_response if error_response

    formatted_time(query_value)
  end

  def validate_time_units(units)
    unknown_formats = []
    units.each do |unit|
      unknown_formats << unit unless AVAILABLE_TIME_UNITS.keys.include?(unit)
    end
    return if unknown_formats.empty?

    [400, {}, ["Unknown time format #{unknown_formats}"]]
  end

  def formatted_time(query_value)
    abnormal_format = split_to_abnormal_format(query_value)
    format = ruby_format_string(abnormal_format)
    [200, {}, [Time.now.strftime(format)]]
  end

  def split_to_abnormal_format(query_value)
    str = query_value
    format = []

    loop do
      index = str.index("%")
      unless index
        format << str
        break
      end

      format << str[0..index - 1]
      str = str[index..]

      format << str[0..2]
      str = str[3..]
    end
    format
  end

  def ruby_format_string(abnormal_format)
    format = ""
    abnormal_format.each do |item|
      if item.start_with?("%")
        format << URI.unescape(item)
      else
        format << "%#{AVAILABLE_TIME_UNITS[item]}"
      end
    end
    format
  end
end
