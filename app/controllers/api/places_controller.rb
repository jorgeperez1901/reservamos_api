class Api::PlacesController < ApplicationController

  def collection
    handle_errors do
      
      validate_params_collection

      api_places = HTTParty.get("https://search.reservamos.mx/api/v2/places").parsed_response

      group_places = api_places.group_by{|place|place["result_type"]}
      
      places = group_places[params["result_type"]]

      places_exist?(places)

      return render create_json_response({"has_errors" => false, "message" => "Se encontraron places con result_type #{params["result_type"]}", "result" => places}, 200, [], "")
    end
  end

  private

  def validate_params_collection
    raise ArgumentError, "Parametro result_type no debe ser vacío" if params["result_type"].blank?
  end

  def places_exist?(places)
    raise ActiveRecord::RecordNotFound, "Places no encontradas con result_type #{params["result_type"]}" if places.blank?
  end

end
