class ApplicationController < ActionController::API
  before_action :authenticate_request

  def create_json_response(json_data, code, errors, backtraces) 
    {
      json: {
        response: json_data,
        errors: errors,
        backtrace_error: backtraces
      },
      status: code
    }
  end

  def handle_errors(&block)
    begin
      yield    
    rescue ActiveRecord::RecordNotSaved => e
        render_error_response(e.message, 500)
    rescue ActiveRecord::RecordNotFound => e
      render_error_response(e.message, 404)
    rescue ArgumentError => e
      render_error_response(e.message, 422)
    rescue Exception => e
      render_error_response(e.message, 500)
    end  
  end

  def render_error_response(message, status)
    render create_json_response({"has_errors" => true, "message" => message}, status, nil, $!.backtrace)
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    raise ActiveRecord::RecordNotFound if header.blank?

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)

    raise ActiveRecord::RecordNotFound if decoded.blank?

    @current_user = User.find(decoded[:user_id])
  end


end
