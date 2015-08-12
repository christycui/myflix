Fabricator(:invitation) do
  friend_name { Faker::Name.name }
  email { Faker::Internet.email }
  message { Faker::Lorem.sentences.join() }
end