json.array!(@websites) do |website|
  json.extract! website, :id, :label, :profil_id_ga, :url_root, :count_page, :schemes, :types
  json.url website_url(website, format: :json)
end
