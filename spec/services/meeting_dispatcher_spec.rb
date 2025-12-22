require 'rails_helper'

RSpec.describe MeetingDispatcher do
  let(:captain) { create(:user, role: :captain) }
  let(:workspace) { captain.workspace }
  let(:meeting) { create(:meeting, workspace: workspace, captain: captain) }
  let!(:mission) { create(:mission, meeting: meeting) }

  describe "#call" do
    it "dispatches the meeting and enqueues jobs" do
      expect {
        described_class.new(meeting).call
      }.to have_enqueued_job(MissionDispatchJob).with(mission)

      expect(meeting.reload.status).to eq("dispatched")
      expect(meeting.dispatched_at).to be_present
    end

    it "fails if meeting has no missions" do
      meeting.missions.destroy_all

      service = described_class.new(meeting)
      expect(service.call).to be false
      expect(meeting.errors[:base]).to include("Cannot dispatch empty briefing. Add at least one mission.")
    end
  end
end
