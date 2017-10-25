require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do

    before(:each) do
      @user = FactoryBot.create :user
      get :show, params: { id: @user.id }, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }

  end

  describe "POST #create" do
    
    context "when is successfully created" do

      before(:each) do
        @user_attributes = FactoryBot.attributes_for :user
        post :create, params: { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }

    end

    context "when is not created" do

      before(:each) do
        @invalid_user_attributes = { 
          password: "123123123", 
          password_confirmation: "123123123"
        }

        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it "renders a JSON with 'errors' key" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON errors on why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }

    end

  end

  describe "PUT/PATCH #update" do

    context "when it is successfully updated" do

      before(:each) do
        @user = FactoryBot.create :user
        update_params = { 
          id: @user.id, 
          user: { email: "newmail@a.com" } 
        }
        patch :update, params: update_params, format: :json
      end

      it "renders the JSON representation for the updated user" do

      end

      it { should respond_with 200 }

    end

    context "when it is not created" do

      before(:each) do
        @user = FactoryBot.create :user
        invalid_update_params = { 
          id: @user.id, 
          user: { email: "bademail.com" }
        }
        patch :update, params: invalid_update_params, format: :json
      end

      it "renders an errors JSON" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON errors on why the users could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }

    end

  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryBot.create :user
      delete :destroy, params: { id: @user.id }, format: :json
    end

    it { should respond_with 204 }

  end

end
