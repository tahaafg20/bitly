class User < ActiveRecord::Base
  has_many :urls
  validates_presence_of :name, :email
  include BCrypt
  # validates :email, uniqueness: {casesensitive: false}
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end