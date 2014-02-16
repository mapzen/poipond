class User < ActiveRecord::Base

  has_many :changesets, -> { order('changesets.created_at DESC') }
  has_many :pois, -> { distinct }, :through => :changesets

  validates :provider, :uid, :token, :secret, :email, :display_name, presence: true
  validates :email, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def osm_access_token
    @osm_access_token ||= OAuth::AccessToken.new(OSM_CLIENT, self.token, self.secret)
  end

end
