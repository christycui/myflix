require 'rails_helper'

RSpec.describe Category, :type => :model do
  it { should have_many(:videos)}
  describe "#recent_videos" do
    it "returns an array of 6 videos in descending recency if there are more than six videos in the category" do
      commedies = Category.create(name: "Commedies")
      family_guy = Video.create(title: 'Family Guy', description: "Family Guy", category: commedies)
      monk = Video.create(title: 'Monk', description: "Monk", category: commedies)
      south_park = Video.create(title: 'South Park', description: "South Park", category: commedies)
      futurama = Video.create(title: 'Futurama 2', description: 'Futurama', category: commedies)
      family_guy2 = Video.create(title: 'Family Guy 2', description: "Family Guy", category: commedies)
      monk2 = Video.create(title: 'Monk 2', description: "Monk", category: commedies)
      south_park2 = Video.create(title: 'South Park', description: "South Park", category: commedies)
      futurama2 = Video.create(title: 'Futurama 2', description: 'Futurama', category: commedies)
      expect(commedies.recent_videos).to eq([futurama2, south_park2, monk2, family_guy2, futurama, south_park])
    end
    
    it "returns an array of all videos in descending recency if there are fewer than six videos in the category" do
      commedies = Category.create(name: "Commedies")
      family_guy = Video.create(title: 'Family Guy', description: "Family Guy", category: commedies)
      monk = Video.create(title: 'Monk', description: "Monk", category: commedies)
      south_park = Video.create(title: 'South Park', description: "South Park", category: commedies)
      futurama = Video.create(title: 'Futurama 2', description: 'Futurama', category: commedies)
      expect(commedies.recent_videos).to eq([futurama, south_park, monk, family_guy])
    end
    
    it "returns an empty string if there's no videos in the cateogry" do
      commedies = Category.create(name: "Commedies")
      expect(commedies.recent_videos).to eq([])
    end
  end
end