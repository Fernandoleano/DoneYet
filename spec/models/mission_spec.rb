require 'rails_helper'

RSpec.describe Mission, type: :model do
  it "has a valid factory" do
    expect(build(:mission)).to be_valid
  end

  it { should belong_to(:meeting) }
  it { should belong_to(:agent).class_name('User') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:due_at) }
  it { should define_enum_for(:status).with_values(pending: 0, done: 1, canceled: 2).with_default(:pending) }
  it { should define_enum_for(:dispatch_status).with_values(pending: 0, sent: 1, failed: 2).with_default(:pending).with_prefix(:dispatch) }
end
