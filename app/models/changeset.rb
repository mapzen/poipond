class Changeset

  attr_accessor :user
  attr_accessor :id

  def initialize(params={})
    self.user = params[:user]
    raise 'Missing user' if user.nil?
  end

  def changeset_xml
    xml = '<osm>'
    xml << '<changeset>'
    xml << '<tag k="created_by" v="POI Pond App"/>'
    xml << '<tag k="comment" v="Adding POI from POI Pond App: http://poipond.com"/>'
    xml << '</changeset>'
    xml << '</osm>'
    xml
  end

  def create
    response = user.osm_access_token.put("#{OSM_API_BASE}/changeset/create", changeset_xml,
      {'Content-Type'=>'application/xml'})
    self.id = response.body
  end

  def close
    response = user.osm_access_token.put("#{OSM_API_BASE}/changeset/#{id}/close")
  end

end
