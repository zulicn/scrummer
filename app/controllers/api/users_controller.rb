class Api::UsersController < ApiController
  before_filter :restrict_api_access, except: [:create, :confirm]

  #Creates new user with provided parameters
  def create
    user = User.new(user_params)
    user.is_active = false
    user.save!
    begin
      UserMailer.confirmation_email(user).deliver
    rescue
      puts 'Failed to send email'
    end
    render response: { :message => "User created."}
  end

  #Updates information of user with specified id.
  def update
    User.find(params[:id]).update(update_params)
    render response: { :message => "User successfully updated."}
  end

  #Changes password of user with specified id
  def change_password
    user = User.find(params[:id])
    if user.try(:authenticate, params[:old_password])
      user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      render response: { :message => "Password successfully changed."}
    end
  end

  #Deactivates account of user, and sets 'is_active' field to false.
  def destroy
    User.find(params[:id]).update(:is_active => false)
    render response: { :message => "You are deactivated."}
  end

  #Helper method to decode user session token.
  def confirm
    decoded_token = Domain::Api::AuthToken.decode(params[:token])
    User.find(decoded_token[:user_id]).update(is_active: true)
    redirect_to root_path
  end

  def reset_password
      user = User.find(params[:id])
      #ovdje neka funkcija za random generisanje stringa
      @new_password='novi123'
      user.update(password: @new_password)
       begin
      UserMailer.reset_password(user).deliver
    rescue
      puts 'Failed to send email'
    end
    render response: { :message => "Password successfully reseted."}
  end

  #Parameters for creating new user
  private
  def user_params
    params.permit(:firstname, :lastname, :email, :username, :password, :password_confirmation)
  end

  #Parameters for updating information of existing user
  def update_params
    params.permit(:firstname, :lastname, :email, :username)
  end
end