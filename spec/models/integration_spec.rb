require 'rails_helper'

RSpec.describe Integration, type: :model do
  it "has a valid factory" do
    expect(build(:integration)).to be_valid
  end

  it { should belong_to(:workspace) }
  it { should define_enum_for(:provider).with_values(slack: 0, zoho_cliq: 1) }
  it { should validate_presence_of(:provider) }

  it do
    create(:integration)
    should validate_uniqueness_of(:workspace_id).scoped_to(:provider).with_message("already has an integration for this provider")
  end
end
