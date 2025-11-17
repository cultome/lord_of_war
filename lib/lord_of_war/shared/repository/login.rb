class LordOfWar::Shared::Repository::Login
  def find_account_by_user(user_id)
    DB
      .execute('SELECT * FROM users where id = $1', [user_id])
      .map do |rec|
        LordOfWar::Login::Entity::Account.parse_json rec
      end.first
  end
end
