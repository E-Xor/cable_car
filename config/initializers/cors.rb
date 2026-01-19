Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://cablecar.click"
    resource "/assets/*", headers: :any, methods: [:get, :head]
  end
end
