class WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :edit, :update, :destroy]

  # GET /websites
  # GET /websites.json
  def index
    @websites = Website.all
  end

  # GET /websites/1
  # GET /websites/1.json
  def show
  end

  # GET /websites/new
  def new
    @website = Website.new
  end

  # GET /websites/1/edit
  def edit
  end

  # POST /websites
  # POST /websites.json
  def create
    @website = Website.new(website_params)
    @website.schemes.delete_if { |x| x.empty? }
    @website.types.delete_if { |x| x.empty? }
    @website.advertisers.delete_if { |x| x.empty? }
    respond_to do |format|
      if @website.save
        format.html { redirect_to @website, notice: 'Website was successfully created.' }
        format.json { render :show, status: :created, location: @website }
      else
        format.html { render :new }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /websites/1
  # PATCH/PUT /websites/1.json
  def update
    # contraint de laisser un element "" dans le tableu sinon l'enregistrement leve une exception
    params[:website][:advertisers] = website_params[:advertisers].delete_if { |x| x.empty? } if website_params[:advertisers].size > 1
    params[:website][:schemes]= website_params[:schemes].delete_if { |x| x.empty? } if website_params[:schemes].size > 1
    params[:website][:types] = website_params[:types].delete_if { |x| x.empty? } if website_params[:types].size > 1


    respond_to do |format|
      if @website.update(website_params)
        format.html { redirect_to @website, notice: 'Website was successfully updated.' }
        format.json { render :show, status: :ok, location: @website }
      else
        format.html { render :edit }
        format.json { render json: @website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    @website.destroy
    respond_to do |format|
      format.html { redirect_to websites_url, notice: 'Website was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Website.delete_all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_website
    @website = Website.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def website_params
    params.require(:website).permit(:label, :profil_id_ga, :url_root, :count_page, :schemes => [], :types => [], :advertisers => [])
  end
end
