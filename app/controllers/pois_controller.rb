class PoisController < ApplicationController

  def show
    @poi = Poi.find(params[:id])
  end

  def update
    @poi = Poi.find(params[:id])
    @poi.assign_attributes(poi_params)
    poi_changes = @poi.changes
    if @poi.save
      OsmUpload.perform_async(current_user.id, @poi.id, poi_changes)
      redirect_to home_url
    else
      render :edit
    end
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
    poi_changes = @poi.changes
    if @poi.save
      @poi.categories << Category.find(params[:category_id]) if params[:category_id]
      OsmUpload.perform_async(current_user.id, @poi.id, poi_changes)
      redirect_to home_url
    else
      render :new
    end
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
