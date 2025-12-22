require 'rails_helper'

RSpec.describe Workspace, type: :model do
  it "has a valid factory" do
    expect(build(:workspace)).to be_valid
  end

  it { should have_many(:users).dependent(:destroy) }
  it { should validate_presence_of(:name) }
end
