require 'spec_helper'

describe Vote do
  it { should belong_to :votable }
  it { should respond_to :votable_id }
  it { should respond_to :votable_type }
  it { should respond_to :user_id }
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }
end
