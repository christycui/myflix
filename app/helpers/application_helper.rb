module ApplicationHelper
  def options_for_rating(selected=nil)
    options_for_select((1..5).map { |n| [pluralize(n, "Star"), n] }, selected)
  end

  def options_for_ratings_filter
    options_for_select((10..50).map { |num| num / 10.0 }.each { |number| number })
  end
end