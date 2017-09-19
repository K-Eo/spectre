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
  email: "eo@spectre.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.272432,
  lng: -97.6816656,
  first_name: "Eo",
  last_name: "Knight",
  company_id: spectre.id
)
eo.skip_confirmation!
eo.save!

kat = User.new(
  email: "kat@spectre.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.2668944,
  lng: -97.678272,
  first_name: "Kat",
  last_name: "Evans",
  company_id: spectre.id
)
kat.skip_confirmation!
kat.save!

jo = User.new(
  email: "jo@spectre.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.2681067,
  lng: -97.6782673,
  first_name: "Jo",
  last_name: "Davis",
  company_id: spectre.id
)
jo.skip_confirmation!
jo.save!

spectre_ids = [eo.id, kat.id, jo.id]

# Ghost company
ghost = Company.create!(name: 'Ghost Inc.')

mia = User.new(
  email: "mia@ghost.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.245328,
  lng: -97.6950679,
  first_name: "Mia",
  last_name: "Woods",
  company_id: ghost.id
)
mia.skip_confirmation!
mia.save!

lee = User.new(
  email: "lee@ghost.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.2684659,
  lng: -97.6790971,
  first_name: "Lee",
  last_name: "Park",
  company_id: ghost.id
)
lee.skip_confirmation!
lee.save!

tom = User.new(
  email: "tom@ghost.com",
  password: "password",
  password_confirmation: "password",
  lat: 17.2687989,
  lng: -97.6781947,
  first_name: "Tom",
  last_name: "Miller",
  company_id: ghost.id
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
