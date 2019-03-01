class Api::V2::SessionsController < ApplicationController
    respond_to :json

    def create
      user = User.find_by(email: sessions_params[:email])

      if user && user.valid_password?(sessions_params[:password])
        sign_in user, store: false
        user.generate_authentication_token!
        user.save
        render json: user, status: 200
      else
        render json: { errors: 'Invalid password or email' }, status: 401
      end
    end

    def destroy
    end

    private

    def sessions_params 
      params.require(:session).permit(:email, :password)
    end

end
