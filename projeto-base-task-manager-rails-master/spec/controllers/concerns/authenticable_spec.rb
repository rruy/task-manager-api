require 'rails_helper'

RSpec.describe Authenticable do
    controller(ApplicationController) do #Controller Anonimo
        include Authenticable     
    end

    let(:app_controller) { subject }
    
    describe '#current_user' do
        let(:user) { create(:user) }

        before do
          req = double(:headers => { 'Authorization' => user.auth_token } )  
          allow(app_controller).to receive(:request).with(args).and_returns(result)
        end

        it 'returns the user from the authorization header' do
            expect(app_controller.current_user).to eq(user)
        end
    end
end

# def current_user
#     User.find_by(auth_token: request.headers['Authorization'])
# end