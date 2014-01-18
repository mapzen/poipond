class User < ActiveRecord::Base

  validates :provider, :uid, :token, :secret, :email, :display_name, presence: true
  validates :email, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

end
