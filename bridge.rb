module Bridge

  BASE_URL = "https://sync.bankin.com/v2"
	#Bridge creds
  @@client_id = ENV['BRIDGE_CLIENT_ID']
  @@client_secret = ENV['BRIDGE_CLIENT_SECRET']
  @@bridge_creds_hash = {"client_id" => @@client_id, "client_secret" => @@client_secret}

  @@bridge_version = "2018-06-15"
  @@bridge_version_hash = { "Bankin-Version" => @@bridge_version }
 
  #Basic HTTP Calls
	def get_bridge_request(url, headers, query)
		result = HTTParty.get(url.to_str, 
      :query =>  query, 
      :headers => headers
    )
    return result
	end

	def post_bridge_request(url, headers, query)
		result = HTTParty.post(url.to_str, 
      :query =>  query, 
      :headers => headers
    )
    return result
	end

  def put_bridge_request(url, headers, query)
    result = HTTParty.put(url.to_str, 
      :query =>  query, 
      :headers => headers
    )
    return result
  end

  def delete_bridge_request(url, headers, query)
    result = HTTParty.delete(url.to_str, 
      :query =>  query, 
      :headers => headers
    )
    return result
  end

  #AUTH UTILITY
  def authentify_headers(email, password)
    result = authenticate_bridge_user(email, password)
    if result
      auth_hash = {"Authorization" => "Bearer #{result["access_token"]}"}
      auth_headers = auth_hash.merge(@@bridge_version_hash)
    else
      auth_headers = @@bridge_version_hash
    end
    return auth_headers
  end

  #BRIDGE ENPOINTS
  #USER RESOURCE
  def create_bridge_user(email, password)
    url = BASE_URL + "/users"
    url_params = { 
      "email" => email,
      "password" => password
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = post_bridge_request(url, headers, query)
    return result
  end

  def authenticate_bridge_user(email, password)
    url = BASE_URL + "/authenticate"
    url_params = {  
      "email" => email,
      "password" => password
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = post_bridge_request(url, headers, query)
    return result
  end

  def logout_bridge_user(email, password)
    url = BASE_URL + "/logout"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = post_bridge_request(url, headers, query)
    return result
  end

  def list_bridge_users
    url = BASE_URL + "/users"
    query = @@bridge_creds_hash
    headers = @@bridge_version_hash
    result = get_bridge_request(url, headers, query)
    return result
  end

  def edit_bridge_user_email(bridge_user_uuid, new_email, password)
    url = BASE_URL + "/users/#{bridge_user_uuid}/email"
    url_params = { 
      "new_email" => new_email,
      "password" => password
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = put_bridge_request(url, headers, query)
    return result
  end

  def edit_bridge_user_password(bridge_user_uuid, current_password, new_password)
    url = BASE_URL + "/users/#{bridge_user_uuid}/password"
    url_params = { 
      "current_password" => current_password,
      "new_password" => new_password
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = put_bridge_request(url, headers, query)
    return result
  end

  def delete_user(bridge_user_uuid, password)
    url = BASE_URL + "/users/#{bridge_user_uuid}"
    url_params = { 
      "password" => password
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = delete_bridge_request(url, headers, query)
    return result
  end

  def delete_all_users #Sandbox only
    url = BASE_URL + "/users"
    query = @@bridge_creds_hash
    headers = @@bridge_version_hash
    result = delete_bridge_request(url, headers, query)
    return result
  end

  def get_email_validation_funnel_url(email, password)
    url = BASE_URL + "/connect/users/email/confirmation/url"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def check_email_validation(email, password)
    url = BASE_URL + "/users/me/email/confirmation"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  #BANK RESOURCE
  def list_banks
    url = BASE_URL + "/banks"
    url_params = { 
      "limit" => "500"
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_bank(bank_id)
    url = BASE_URL + "/banks/#{bank_id}"
    query = @@bridge_creds_hash
    headers = @@bridge_version_hash
    result = get_bridge_request(url, headers, query)
    return result
  end

  #ACCOUNT RESOURCE
  def list_accounts(email, password)
    url = BASE_URL + "/accounts"
    url_params = { 
      "limit" => "50"
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_account(email, password, account_id)
    url = BASE_URL + "/accounts/#{account_id}"
    url_params = { 
      "limit" => "50"
    }
    query = @@bridge_creds_hash.merge(url_params)
     headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  #ITEM RESOURCE
  def get_add_bank_funnel_url(email, password)
    url = BASE_URL + "/connect/items/add/url"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_edit_bank_funnel_url(email, password, item_id)
    url = BASE_URL + "/connect/items/edit/url"
    url_params = {
      "item_id" => item_id
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def list_items(email, password, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/items"
    url_params = Hash.new
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?
    
    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_item(email, password, item_id)
    url = BASE_URL + "/items/#{item_id}"
    url_params = { 
      "limit" => "10"
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def refresh_item(email, password, item_id)
    url = BASE_URL + "/items/#{item_id}/refresh"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = post_bridge_request(url, headers, query)
    return result
  end
  
  def get_refresh_status(email, password, item_id)
    url = BASE_URL + "/items/#{item_id}/refresh/status"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def send_otp(email, password, item_id, otp_code)
    url = BASE_URL + "/items/#{item_id}/mfa"
    url_params = { 
      "otp" => "#{otp_code}",
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = authentify_headers(email, password)
    result = post_bridge_request(url, headers, query)
    return result
  end

  def delete_item(email, password, item_id)
    url = BASE_URL + "/items/#{item_id}"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = delete_bridge_request(url, headers, query)
    return result
  end

  def pro_account_validation_funnel_url(email, password)
    url = BASE_URL + "/connect/items/pro/confirmation/url"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  #TRANSACTION RESOURCE
  def list_transactions(email, password, since=nil, to=nil, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/transactions"
    url_params = Hash.new
    url_params["since"] = before unless before.nil?
    url_params["to"] = before unless before.nil?
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def list_updated_transactions(email, password, since=nil, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/transactions/updated"
    url_params = Hash.new
    url_params["since"] = before unless before.nil?
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end

    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_transaction(email, password, transaction_id)
    url = BASE_URL + "/transactions/#{transaction_id}"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def list_account_transactions(email, password, account_id, since=nil, to=nil, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/accounts/#{account_id}/transactions"
    url_params = Hash.new
    url_params["since"] = before unless before.nil?
    url_params["to"] = before unless before.nil?
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end

    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def list_account_updated_transactions(email, password, account_id, since=nil, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/accounts/#{account_id}/transactions/updated"
    url_params = Hash.new
    url_params["since"] = before unless before.nil?
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end

    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  #STOCK RESOURCE
  def list_stocks(email, password, before=nil, after=nil, limit=nil)
    url = BASE_URL + "/stocks"
    url_params = Hash.new
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def list_updated_stocks(email, password, before=nil, after=nil, limit=nil, since=nil)
    url = BASE_URL + "/stocks/updated"
    url_params = Hash.new
    url_params["since"] = before unless before.nil?
    url_params["before"] = before unless before.nil?
    url_params["after"] = before unless before.nil?
    url_params["limit"] = before unless before.nil?

    unless url_params.empty?
      query = @@bridge_creds_hash.merge(url_params)
    else
      query = @@bridge_creds_hash
    end
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_stock(email, password, stock_id)
    url = BASE_URL + "/stocks/#{stock_id}"
    query = @@bridge_creds_hash
    headers = authentify_headers(email, password)
    result = get_bridge_request(url, headers, query)
    return result
  end

  #CATEGORY RESOURCE
  def list_categories
    url = BASE_URL + "/categories"
    url_params = { 
      "limit" => "200"
    }
    query = @@bridge_creds_hash.merge(url_params)
    headers = @@bridge_version_hash
    result = get_bridge_request(url, headers, query)
    return result
  end

  def get_category(category_id)
    url = BASE_URL + "/categories/#{category_id}"
    query = @@bridge_creds_hash
    headers = @@bridge_version_hash
    result = get_bridge_request(url, headers, query)
    return result
  end
end