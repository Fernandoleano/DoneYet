require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it "has a valid factory" do
    expect(build(:meeting)).to be_valid
  end

  it { should belong_to(:workspace) }
  it { should belong_to(:captain).class_name('User') }
  it { should have_many(:missions).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should define_enum_for(:status).with_values(briefing: 0, dispatched: 1, closed: 2).with_default(:briefing) }
end
