require 'rails_helper'

RSpec.describe "WorkspaceAnnouncements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/workspace_announcements/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/workspace_announcements/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /mark_as_read" do
    it "returns http success" do
      get "/workspace_announcements/mark_as_read"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /toggle_pin" do
    it "returns http success" do
      get "/workspace_announcements/toggle_pin"
      expect(response).to have_http_status(:success)
    end
  end

end
