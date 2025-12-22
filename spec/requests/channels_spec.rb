require 'rails_helper'

RSpec.describe "Channels", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/channels/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/channels/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/channels/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /join" do
    it "returns http success" do
      get "/channels/join"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /leave" do
    it "returns http success" do
      get "/channels/leave"
      expect(response).to have_http_status(:success)
    end
  end

end
