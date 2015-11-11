class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name ["myflix", Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader
  
  validates_presence_of :title, :description
  
  def self.search_by_title(str)
    return [] if str.blank?
    where("lower(title) LIKE ?", "%#{str.downcase}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def self.search(query)
    search_definition = {
      query: {
        multi_match: {
        query: query, 
        operator: "and",
        fields: [ "title", "description" ] 
        }
      }
    }
    __elasticsearch__.search search_definition
  end

  def as_indexed_json(options={})
    as_json(only: [:title, :description])
  end
end