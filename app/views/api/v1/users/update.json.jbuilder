json.(@profile.user, :first_name, :last_name, :created_at, :email)

json.company do
  json.name @profile.user.company.name
end
