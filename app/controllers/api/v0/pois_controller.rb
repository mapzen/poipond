class Api::V0::PoisController < Api::V0Controller

  def closest
    @pois = Poi.closest(params[:lat], params[:lon])
  end

end
