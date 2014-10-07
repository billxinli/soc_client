require_relative './sign_data_source'

class TtcDataSource < SignDataSource

  base_uri 'webservices.nextbus.com/service'

  def initialize(options = {})
    options = { agency: 'ttc' }.merge(options)

    @options = { a: options[:agency] }
  end

  def get_data(options = {})
    options = { command: 'predictions', stopId: '10210', routeTag: '511' }.merge(options)

    command = options[:command]
    stopId = options[:stopId]
    routeTag = options[:routeTag]

    @options.merge!({ command: command, stopId: stopId, routeTag: routeTag })

    ttc = self.class.get('/publicXMLFeed', query: @options)

    predictions = ttc['body']['predictions']['direction']

    if predictions
      predictions = if predictions.is_a?(Hash)
                      predictions['prediction']
                    else
                      predictions.collect { |x| x['prediction'] }.flatten
                    end

      if predictions.is_a?(Array)
        predictions = predictions.sort! { |a, b| a['epochTime'] <=> b['epochTime'] }
        prediction = predictions.first
      else
        prediction = predictions
      end
      minutes = prediction['minutes']
      prediction_time = Time.at(prediction['epochTime'].to_f/1000).strftime('%-I:%M%p')
      "#{routeTag} #{minutes} #{prediction_time}"[0..-2]
    else
      "#{routeTag} N/A"
    end
  end
end
