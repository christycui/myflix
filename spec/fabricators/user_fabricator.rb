Fabricator(:user) do
  email_address { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end