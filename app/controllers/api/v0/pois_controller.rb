class Api::V0::PoisController < Api::V0Controller

  def show
    @poi = Poi.find(params[:id])
    @poi.sync_from_osm(current_user)
    @poi.reload
  end

  def update
debugger
i=0
  end

  def create
debugger
i=0
  end

  def closest
    @pois = Poi.closest(params[:lat], params[:lon])
  end

end
