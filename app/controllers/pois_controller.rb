class PoisController < ApplicationController

  def show
    @poi = Poi.find(params[:id])
    @poi.reload
  end

  def update
    @poi = Poi.find(params[:id])
    @poi.update_attributes(poi_params)
    @poi.sync_to_osm(current_user)
    redirect_to home_url
  end

  def new
    @category = Category.find(params['poi'].delete('category_id'))
    @poi = Poi.new(poi_params)
    unless @category && @poi.lat && @poi.lon
      redirect_to choose_category_url
    end
  end

  def create
    @poi = Poi.new(poi_params)
    @poi.osm_type = 'node'
    @poi.save
    @poi.categories << Category.find(params[:category_id]) if params[:category_id]
    @poi.sync_to_osm(current_user)
    redirect_to home_url
  end

  def choose_category
    if params[:category_id]
      category = Category.find(params[:category_id])
      children = category.children
      if children.empty?
        redirect_to choose_location_url(category_id: category.id)
      else
        @categories = children
      end
    else
      @categories = Category.where(parent_id: nil).order(:name)
    end
  end

  def choose_location
    @poi = Poi.new
  end

  private

  def poi_params
    params.require(:poi).permit(:name, :addr_housenumber, :addr_street, :addr_city, :addr_postcode, :phone, :website, :lat, :lon)
  end

end
