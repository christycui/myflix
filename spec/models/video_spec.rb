require 'rails_helper'

RSpec.describe Video, :type => :model do 
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  describe "#search_by_title" do
    it "returns an empty array if no vodeo title contains the string" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'monk'
      expect(Video.search_by_title(str)).to eq([])
    end
    it "returns the matching video in an array if one video title contains the string" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'Family'
      expect(Video.search_by_title(str)).to eq([video])
    end
    it "returns multiple videos in an array if multiple videos titles contain the string" do
      family_guy = Video.create(title: "Family Guy", description: "Funny TV series")
      family_guy_2 = Video.create(title: "Family Guy 2", description: "Family Guy Season 2")
      str = "Family"
      expect(Video.search_by_title(str)).to eq([family_guy, family_guy_2])
    end
  end
end