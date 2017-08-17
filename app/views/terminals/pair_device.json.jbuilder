json.(@device, :imei, :os, :phone, :owner, :model)

if !@device.new_record?
  json.(@device, :created_at, :updated_at)
end

if @device.errors.any?
  json.errors @device.errors
end
