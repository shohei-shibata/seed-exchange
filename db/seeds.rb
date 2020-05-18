# Create a main sample user.
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate plants for a subset of users
users = User.order(:created_at).take(6)
50.times do
  name = Faker::Food.vegetables 
  name_latin = Faker::Lorem.sentence(word_count: 3).delete_suffix('.') 
  users.each { |user| user.plants.create!(name: name, name_latin: name_latin) }
end
