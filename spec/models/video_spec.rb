require 'rails_helper'

RSpec.describe Video, :type => :model do 
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
end