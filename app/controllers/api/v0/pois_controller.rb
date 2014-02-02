class Api::V0::PoisController < Api::V0Controller

  def closest
    @pois = Poi.closest(params[:lat].to_f, params[:lon].to_f)
  end

end
