Rails.application.config.middleware.use OmniAuth::Builder do
  google_client_id = ENV["GOOGLE_CLIENT_ID"].presence
  google_client_secret = ENV["GOOGLE_CLIENT_SECRET"].presence

  if google_client_id && google_client_secret
    provider :google_oauth2, google_client_id, google_client_secret,
             scope: "userinfo.profile,youtube"
  end

  OmniAuth.config.on_failure do |env|
    error_type = env["omniauth.error.type"]
    new_path = "#{env["SCRIPT_NAME"]}#{OmniAuth.config.path_prefix}/failure?message=#{error_type}"
    [301, { "Location" => new_path, "Content-Type" => "text/html" }, []]
  end
end
