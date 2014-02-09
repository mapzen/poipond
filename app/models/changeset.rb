class Changeset

  belongs_to :user
  belongs_to :poi

  validates :user_id, :poi_id, :osm_id, :presence=>true

  before_validation :open_remote, :on => :create

  serialize :changes, Hash

  def close_remote
    response = user.osm_access_token.put("#{OSM_API_BASE}/changeset/#{id}/close")
    self.update_attributes(:is_open=>false)
  end

  private

  def open_remote
    response = user.osm_access_token.put("#{OSM_API_BASE}/changeset/create", create_changeset_xml,
      {'Content-Type'=>'application/xml'})
    self.osm_id = response.body
    self.is_open = true
  end

  def create_changeset_xml
    xml = '<osm>'
    xml << '<changeset>'
    xml << '<tag k="created_by" v="POI Pond App"/>'
    xml << '<tag k="comment" v="Adding POI from POI Pond App: http://poipond.com"/>'
    xml << '</changeset>'
    xml << '</osm>'
    xml
  end

end
