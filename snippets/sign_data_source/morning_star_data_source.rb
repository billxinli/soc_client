require_relative './sign_data_source'

class MorningStarDataSource < SignDataSource

  base_uri 'webservices.nextbus.com/service'

  def initialize(agency = 'ttc')
    @options = { a: agency }
  end

  def get_predictions_for(stop_id = '10210', route = '511')
    @options.merge!({ 'command' => 'predictions',
                      'stopId' => stop_id,
                      'routeTag' => route })
    ttc = self.class.get('/publicXMLFeed', query: @options)

    predictions = ttc['body']['predictions']['direction']

    if predictions
      predictions = if predictions.is_a?(Hash)
                      predictions['prediction']
                    else
                      predictions.collect { |x| x['prediction'] }.flatten
                    end
      predictions = predictions.sort! { |a, b| a['epochTime'] <=> b['epochTime'] }
      prediction = predictions.first
      minutes = prediction['minutes']
      prediction_time = Time.at(prediction['epochTime'].to_f/1000).strftime('%-I:%M%p')
      "#{route} #{minutes} #{prediction_time}"[0..-2]
    else
      "#{route} N/A"
      nil
    end
  end

  def get_data
    [get_predictions_for(10210, 511),
     get_predictions_for(10773, 509)].join('|')
  end
end