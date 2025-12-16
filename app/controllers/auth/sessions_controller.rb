class Auth::SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])


    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }
    else
      render json: { error: 'Email o contraseña inválidos' }, status: :unauthorized
    end
  end

end
