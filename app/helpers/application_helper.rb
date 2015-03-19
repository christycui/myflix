module ApplicationHelper
  def options_for_rating
    [5, 4, 3, 2, 1].map { |n| [pluralize(n, "Star"), n] }
  end
end
