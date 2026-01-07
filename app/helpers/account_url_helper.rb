module AccountUrlHelper
  def landing_path
    main_app.root_path(script_name: nil)
  end

  def landing_url
    main_app.root_path(script_name: nil)
  end

  def sign_in_path
    main_app.new_session_path(script_name: nil)
  end

  def sign_out_path
    main_app.session_path(script_name: nil)
  end

  def my_accounts_path
    main_app.session_accounts_path(script_name: nil)
  end

  def my_accounts_url
    main_app.session_accounts_url(script_name: nil)
  end

  def redirect_to_sign_in_url
    redirect_to sign_in_url, allow_other_host: true
  end

  def redirect_to_sign_out_url
    redirect_to sign_out_url, allow_other_host: true
  end
end
