require 'rails_helper'

RSpec.describe 'User API', type: :request do
   let!(:user) { create(:user) }
   let(:user_id) { user.id }
   let(:headers) do
     { 
       'Accept' => 'application/vnd.taskmanager.v1',
       'Content-type' => Mime[:json].to_s
     } 
   end

   before { host! 'api.taskmanager.test' }

   describe 'GET /users/:id' do
     before do  
        get "/users/#{user_id}", {}, headers
     end

     context 'when the user exists' do
       it 'returns the users' do
         user_response = JSON.parse(response.body)   
         expect(user_response['id']).to eq(user_id)
       end

       it 'returns status 200' do
         expect(response).to have_http_status(200)
       end
     end

     context 'when the user does not exist' do
       let(:user_id) { 10000 }

       it 'returns status 404' do 
         expect(response).to have_http_status(404)
       end
     end

   end
    
   describe 'POST /users' do
      before do  
        post "/users/", params: { user: user_params }.to_json, headers: headers
      end
 
      context 'when the user params are valid' do
        let(:user_params) { attributes_for(:user, email: 'rr@email.com.br' ) }

        it 'returns status code 201' do 
          expect(response).to have_http_status(201)
        end

        it 'returns json data for the created user' do 
          user_response = JSON.parse(response.body, symbolize_names: true) 
          expect(user_response[:email]).to eq(user_params[:email])
        end
      end
 
      context 'when the user request params are invalid' do
        let(:user_params) {  attributes_for(:user, email: 'invalid_email@') }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns the json data for the errors' do
          user_response = JSON.parse(response.body, symbolize_names: true)
          expect(user_response).to have_key(:errors)
        end

      end
 
   end
 
   describe 'PUT /users/:id' do
     before do
       put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
     end

     context 'when the request params are valid' do
        let(:user_params) { { email: 'new@email.com' } }

       it 'returns status code 200' do
         expect(response).to have_http_status(200)
       end

       it 'returns the json data for the updated user' do
         user_response = JSON.parse(response.body, symbolize_names: true)
         expect(user_response[:email]).to eq(user_params[:email])
       end

     end

     context 'when the user request params are invalid' do
      let(:user_params) {  attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

    end

  end


  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: { }, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end  

    it 'removes the user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end  
  end  

end