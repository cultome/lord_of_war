class LordOfWar::Login::Service::LoginUser
  include LordOfWar::Shared::Service::Responses

  attr_reader :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def execute!
    user = user_repo.find_user_by_email email

    if user.nil?
      puts "[-] User [#{email}] doesnt exists!"

      return error('Credenciales invalidas!')
    elsif BCrypt::Password.new(user.password) != password
      puts "[-] Password for [#{email}] is incorrect!"

      return error('Credenciales invalidas!')
    else
      puts "[-] Login successful for [#{email}]!"

      return success(user)
    end
  end

  private

  def user_repo
    @user_repo ||= LordOfWar::Login::Repository::User.new
  end
end
