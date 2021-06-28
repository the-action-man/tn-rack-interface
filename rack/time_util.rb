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
    unknown_formats = []
    units.each do |unit|
      unknown_formats << unit unless AVAILABLE_TIME_UNITS.keys.include?(unit)
    end
    return if unknown_formats.empty?

    "Unknown time format #{unknown_formats}"
  end

  def formatted_time(query_value)
    abnormal_format = split_to_abnormal_format(query_value)
    format = ruby_format_string(abnormal_format)
    Time.now.strftime(format)
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
    abnormal_format.map do |item|
      if item.start_with?("%")
        URI.unescape(item)
      else
        "%#{AVAILABLE_TIME_UNITS[item]}"
      end
    end.join("")
  end
end


