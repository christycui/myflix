class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.blank? ? 'N/A' : "#{object.rating}/5.0}"
  end
end