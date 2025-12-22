require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it { should belong_to(:workspace) }
  it { should validate_presence_of(:name) }
  it { should define_enum_for(:role).with_values(agent: "agent", captain: "captain").with_default("agent").backed_by_column_of_type(:string) }
end
