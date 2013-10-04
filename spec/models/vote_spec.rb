require 'spec_helper'

describe Vote do
  it { should belong_to :votable }
  it { should respond_to :votable_id }
  it { should respond_to :votable_type }
  it { should respond_to :user_id }
end
