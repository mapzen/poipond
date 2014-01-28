class PoisController < ApplicationController

  def show
    @poi = Poi.find(params[:id])
    @poi.sync_from_osm(current_user)
    @poi.reload
  end

  def update
    @poi = Poi.find(params[:id])
    @poi.update_attributes(poi_params)
    @poi.sync_to_osm(current_user)
    redirect_to home_url
  end

  def new
    @poi = Poi.new
  end

  def create
  end

  private

  def poi_params
    params.require(:poi).permit(:name, :addr_housenumber, :addr_street, :addr_city, :addr_postcode, :phone, :website)
  end

end
