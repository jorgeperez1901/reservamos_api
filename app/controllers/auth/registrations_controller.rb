class Auth::RegistrationsController < ApplicationController
  skip_before_action :authenticate_request
  
  def create
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private


  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
end
