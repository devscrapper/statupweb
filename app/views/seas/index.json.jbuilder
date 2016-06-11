json.array!(@seas) do |sea|
  json.extract! sea, :id, :label, :advertiser,:keywords, :label_advertisings
  json.url sea_url(sea, format: :json)
end
