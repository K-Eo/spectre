json.(@user, :first_name, :last_name, :created_at, :email)

json.company do
  json.name @user.company.name
end
