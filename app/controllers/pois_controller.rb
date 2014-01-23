class PoisController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:update, :create]

  def show
    load_poi(params[:osm_id])
  end

  def update
    load_poi(params[:osm_id])
    params.delete('controller')
    params.delete('action')
    params.delete('osm_id')
    @poi.update_attributes(params.symbolize_keys)
    @poi.save
    redirect_to '/'
  end

  def new
    @poi = Poi.new(:user=>current_user, :osm_type=>'node')
  end

  def create
    @poi = Poi.new(:user=>current_user, :osm_type=>'node')
    @poi.update_attributes(params.symbolize_keys)
    @poi.save
    redirect_to '/'
  end

  private

  def load_poi(osm_id)
    id_arr = osm_id.split('-')
    @poi = Poi.new(:user=>current_user, :osm_type=>id_arr[0], :osm_id=>id_arr[1])
    @poi.load_remote_data
  end

end
