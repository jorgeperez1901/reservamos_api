class OpenWeatherClient
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def self.current_weather(lat:, lon:)
    Rails.cache.fetch("weather/#{lat}/#{lon}", expires_in: 30.minutes) do
      response = get(
        '/weather',
        query: {
          lat: lat,
          lon: lon,
          units: 'metric',
          lang: 'es',
          appid: Rails.application.credentials.dig(:openweather, :api_key)
        }
      )
      
      response.success? ? response.parsed_response : nil
    end
  end
end