require_relative './sign_data_source'

class TemperatureDataSource < SignDataSource

  base_uri 'api.openweathermap.org'

  def get_data(options = {})
    options = { location: 'Toronto,ON,Canada' }.merge(options)
    location = options[:location]

    @options = { q: location }

    weather = self.class.get('/data/2.5/weather', query: @options)
    high_temp = kelvin_to_celsius(weather['main']['temp_max'])
    low_temp = kelvin_to_celsius(weather['main']['temp_min'])
    temp = kelvin_to_celsius(weather['main']['temp'])
    temperatures = [high_temp, low_temp, temp]
    "#{(temperatures.reduce(:+).to_f / temperatures.size).round(1)}C"
  end

  private
  def kelvin_to_celsius(k)
    k - 273.15
  end
end
