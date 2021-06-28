require_relative 'array_format_time_util'

class TimeUtil
  AVAILABLE_TIME_UNITS =
    {
      "year" => "Y",
      "month" => "m",
      "day" => "d",
      "hour" => "H",
      "minute" => "M",
      "second" => "S",
    }.freeze

  def validate_time_units(units)
    unknown_formats = units.reject { AVAILABLE_TIME_UNITS.keys.include?(_1) }
    return if unknown_formats.empty?

    "Unknown time format #{unknown_formats}"
  end

  def formatted_time(query_value)
    array_format = ArrayFormatTimeUtil.new(query_value).split_to_array
    string_format = convert_to_string_format(array_format)
    Time.now.strftime(string_format)
  end

  def convert_to_string_format(array_format)
    array_format.map do |item|
      if item.start_with?("%")
        URI.unescape(item)
      else
        "%#{AVAILABLE_TIME_UNITS[item]}"
      end
    end.join("")
  end
end
