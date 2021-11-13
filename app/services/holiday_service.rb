class HolidayService
  def self.top_3_holidays
    content = conn.get
    body = parse_response(content)
    body.first(3).map do |holiday_hash|
      holiday_hash[:name]
    end
  end

  def self.parse_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://date.nager.at/api/v2/NextPublicHolidays/US")
  end
end