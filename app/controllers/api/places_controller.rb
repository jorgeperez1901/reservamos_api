class Api::PlacesController < ApplicationController

APIKEY='0eebd1fcf852d29ca0340c5c451d4c9a'

  def collection
    handle_errors do
      
      validate_params_collection

      api_places = HTTParty.get("https://search.reservamos.mx/api/v2/places").parsed_response

      group_places = api_places.group_by{|place|place["result_type"]}

      places = group_places[params["result_type"]]

      places_exist?(places)

      reponse_places = get_list_weather(places)

      return render create_json_response({"has_errors" => false, "message" => "Se encontraron places con result_type #{params["result_type"]}", "result" => reponse_places}, 200, [], "")
    end
  end

  private

  def validate_params_collection
    raise ArgumentError, "Parametro result_type no debe ser vacío" if params["result_type"].blank?
  end

  def places_exist?(places)
    raise ActiveRecord::RecordNotFound, "Places no encontradas con result_type #{params["result_type"]}" if places.blank?
  end


  def get_list_weather(places)
    places.each do |place|
      
      response_weather = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{place["lat"]}&lon=#{place["long"]}&appid=#{APIKEY}&units=metric&lang=es").parsed_response

      if response_weather["cod"] == 200
        place["weather"] = response_weather["weather"]
        place["temp"] = "#{response_weather["main"]["temp"].round(1)} °C"
      end

    end
    return places
  end

end
