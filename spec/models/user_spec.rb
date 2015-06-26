require "rails_helper"

describe User do
  it { should validate_presence_of(:email_address).on(:create) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email_address) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order("position") }
  it { should have_many(:relationships) }
  it { should have_many(:followers).through(:relationships) }
end
