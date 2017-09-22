# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Spectre Company
spectre = Company.create!(name: 'Spectre Inc.')

eo = User.new(
  company_id: spectre.id,
  email: "eo@spectre.com",
  first_name: "Eo",
  last_name: "Knight",
  lat: 17.272432,
  lng: -97.6816656,
  password: "password",
  password_confirmation: "password",
  role: :admin
)
eo.skip_confirmation!
eo.save!

kat = User.new(
  company_id: spectre.id,
  email: "kat@spectre.com",
  first_name: "Kat",
  last_name: "Evans",
  lat: 17.2668944,
  lng: -97.678272,
  password: "password",
  password_confirmation: "password",
  role: :moderator
)
kat.skip_confirmation!
kat.save!

jo = User.new(
  company_id: spectre.id,
  email: "jo@spectre.com",
  first_name: "Jo",
  last_name: "Davis",
  lat: 17.2681067,
  lng: -97.6782673,
  password: "password",
  password_confirmation: "password",
  role: :user
)
jo.skip_confirmation!
jo.save!

spectre_ids = [eo.id, kat.id, jo.id]

# Ghost company
ghost = Company.create!(name: 'Ghost Inc.')

mia = User.new(
  company_id: ghost.id,
  email: "mia@ghost.com",
  first_name: "Mia",
  last_name: "Woods",
  lat: 17.245328,
  lng: -97.6950679,
  password: "password",
  password_confirmation: "password",
  role: :admin
)
mia.skip_confirmation!
mia.save!

lee = User.new(
  company_id: ghost.id,
  email: "lee@ghost.com",
  first_name: "Lee",
  last_name: "Park",
  lat: 17.2684659,
  lng: -97.6790971,
  password: "password",
  password_confirmation: "password",
  role: :moderator
)
lee.skip_confirmation!
lee.save!

tom = User.new(
  company_id: ghost.id,
  email: "tom@ghost.com",
  first_name: "Tom",
  last_name: "Miller",
  lat: 17.2687989,
  lng: -97.6781947,
  password: "password",
  password_confirmation: "password",
  role: :user
)
tom.skip_confirmation!
tom.save!

ghosts = [mia, lee, tom]

# Alerts
40.times do
  alert = Alert.create!(
    company_id: spectre.id,
    issuing_id: spectre_ids.sample
  )

  alert.guards << ghosts.sample(2)
end
