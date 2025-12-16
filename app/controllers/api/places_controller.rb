class Api::PlacesController < ApplicationController

  def collection
    handle_errors do
      
      validate_params_collection()

      api_places = get_places

      group_places = api_places.group_by{|place|place["result_type"]}

      places = group_places[params["type"]]

      places_exist?(places)

      response_places = attach_weather_to_places(places)

      return render create_json_response({"has_errors" => false, "message" => "Se encontraron places con type #{params["type"]}", "result" => response_places}, 200, [], "")
    end
  end

  def show
    handle_errors do
      validate_params_show()

      response_forecast = get_forecast(params["lat"],params["lon"])

      return render create_json_response({"has_errors" => false, "message" => "Se encontraron forecast", "result" => response_forecast}, 200, [], "")
    end

  end

  private

  def validate_params_collection
    raise ArgumentError, "Parametro type no debe ser vacío" if params["type"].blank?
  end


  def validate_params_show
    raise ArgumentError, "Parametro lon no debe ser vacío" if params["lon"].blank?
    raise ArgumentError, "Parametro lat no debe ser vacío" if params["lat"].blank?
  end

  def places_exist?(places)
    raise ActiveRecord::RecordNotFound, "Places no encontradas con type #{params["type"]}" if places.blank?
  end


  def attach_weather_to_places(places)
    places.map do |place|
      weather = get_weather(place)

      next place unless weather_success?(weather)

      place.merge(
        'weather' => weather['weather'],
        'temp'    => format_temp(weather.dig('main', 'temp'))
      )
    end
  end

  def get_places
    HTTParty.get("https://search.reservamos.mx/api/v2/places").parsed_response
  end

  def get_weather(place)
    OpenWeatherClient.current_weather(
      lat: place['lat'],
      lon: place['long']
    )
  end

  def get_forecast(lat,lon)
    OpenForecastClient.current_forecast(
      lat: lat,
      lon: lon
    )
  end

  def weather_success?(weather)
    weather.present? && weather['cod'].to_i == 200
  end

  def format_temp(temp)
    return nil if temp.blank?

    "#{temp.round(1)} °C"
  end

end
