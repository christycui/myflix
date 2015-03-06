require 'rails_helper'

RSpec.describe Video, :type => :model do 
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  describe "search_by_title" do
    it "returns an empty array if no vodeo title contains the string" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'monk'
      expect(Video.search_by_title(str)).to eq([])
    end
    
    it "returns the matching video in an array if there is a exact match" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'Family'
      expect(Video.search_by_title(str)).to eq([video])
    end
    
    it "returns the matching video in an array if there is a partial match" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'Fam'
      expect(Video.search_by_title(str)).to eq([video])
    end
    
    it "returns the matching video in an array if there is a similar match" do
      video = Video.create(title: "Family Guy", description: 'A funny TV series.')
      str = 'family'
      expect(Video.search_by_title(str)).to eq([video])
    end
    
    it "returns multiple videos in an array ordered by created_at if there are multiple matches" do
      family_guy = Video.create(title: "Family Guy", description: "Funny TV series")
      family_guy_2 = Video.create(title: "Family Guy 2", description: "Family Guy Season 2")
      str = "Family"
      expect(Video.search_by_title(str)).to eq([family_guy_2, family_guy])
    end
    
    it "returns an empty array if search string is empty" do
      family_guy = Video.create(title: "Family Guy", description: "Funny TV series")
      family_guy_2 = Video.create(title: "Family Guy 2", description: "Family Guy Season 2")
      str = ""
      expect(Video.search_by_title(str)).to eq([])
    end
    
  end
end