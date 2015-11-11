require 'rails_helper'

RSpec.describe Video, :type => :model do 
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }
  
  describe ".search_by_title" do
    
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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end
end