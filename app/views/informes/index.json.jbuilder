json.array!(@informes) do |informe|
  json.extract! informe, :id, :email, :token
  json.url informe_url(informe, format: :json)
end
