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

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
        query: query, 
        operator: "and",
        fields: [ "title^100", "description^50" ] 
        }
      }
    }
    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << "reviews.body"
    end

    if query.present? && (options[:rating_from].present? || options[:rating_to]).present?
      search_definition[:filter] = {
        range: {
          rating: {
            gte: ( options[:rating_from] if options[:rating_from].present? ),
            lte: ( options[:rating_to] if options[:rating_to].present? )
          }
        }
      }
    end

    __elasticsearch__.search search_definition
  end

  def as_indexed_json(options={})
    as_json(
      only: [:title, :description], 
      include: { 
        reviews: { only: [:body] }
      },
      methods: [:rating]
    )
  end
end