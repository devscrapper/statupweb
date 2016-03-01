require_relative '../../lib/publication'


class TrafficsController < ApplicationController
  before_action :set_traffic, only: [:show, :edit, :update, :destroy]
  include Publication

  # GET /traffics
  # GET /traffics.json
  def index

    @traffics = Traffic.all

  end

  # GET /traffics/1
  # GET /traffics/1.json
  def show

  end

  # GET /traffics/new
  def new
    @websites = Website.all
    @statistics = Statistic.all
    @traffic = Traffic.new
    @traffic.monday_start = Traffic.next_monday(Date.today + @traffic.max_duration_scraping)
  end

  # GET /traffics/1/edit
  def edit
    @websites = Website.all
    @statistics = Statistic.all
    @traffic = Traffic.find(params[:id])
    @website = @traffic.website
    @statistic = @traffic.custom_statistic if @traffic.statistic_type == "custom"
  end

  # POST /traffics
  # POST /traffics.json
  def create

    params[:traffic][:website_id] = params[:website_selected]
    @traffic = Traffic.new(traffic_params)
    ok = @traffic.save
    if ok and @traffic.statistic_type == "custom"
      @statistic = @traffic.build_custom_statistic({:statistic_id => params[:statistic_selected]})
      ok = ok && @statistic.save
    end

    render_after_create_or_update(ok, "Traffic n°#{@traffic.id} was successfully created.")
  end

  def publish


    respond_to do |format|
      begin
        @traffic = Traffic.find(params[:id])

        raise "monday start is older" if @traffic.monday_start < Date.today
        Publication::publish(@traffic.to_hash)

      rescue Exception => e

        format.html { redirect_to traffics_path, notice: "Traffic n°#{params[:id]} was not published : #{e.message}" }

      else
        @traffic.update_attribute(:state, :published)
        format.html { redirect_to traffics_path, notice: 'Traffic was successfully published to enginebot.' }

      end
    end
  end

  def unpublish
    @traffic = Traffic.find(params[:id])

    respond_to do |format|
      begin

        Publication::delete(@traffic.id, Traffic.name.downcase)

      rescue Exception => e

        format.html { redirect_to traffics_path, notice: "Traffic n°#{params[:id]} was not unpublished : #{e.message}" }

      else
        @traffic.update_attribute(:state, :created)
        @traffic.tasks.destroy_all
        @traffic.objectives.destroy_all
        @traffic.visits.destroy_all
        format.html { redirect_to traffics_path, notice: 'Traffic was successfully unpublished to enginebot.' }

      end
    end
  end

  # PATCH/PUT /traffics/1
  # PATCH/PUT /traffics/1.json
  def update
    params[:traffic][:website_id] = params[:website_selected]
    @traffic = Traffic.find_by_id(params[:id])
    ok = @traffic.update(traffic_params)
    if ok and @traffic.statistic_type == "custom"

      unless @statistic = @traffic.custom_statistic
        @statistic = @traffic.build_custom_statistic({:statistic_id => params[:statistic_selected]})
        ok = ok && @statistic.save

      else
        @statistic.update_attribute(:statistic_id, params[:statistic_selected])

      end

    else


    end
    render_after_create_or_update(ok, "Traffic n°#{@traffic.id} was successfully update.")
  end


  # DELETE /traffics/1
  # DELETE /traffics/1.json
  def destroy
    begin
      @traffic.destroy

    rescue Exception => e
      notice = e.message
    else
      notice = 'Traffic was successfully destroyed.'
    end

    respond_to do |format|
      format.html { redirect_to traffics_url, notice: notice }
      format.json { head :no_content }
    end
  end

  def destroy_all

    begin
      Traffic.all.each { |traffic| traffic.destroy }

    rescue Exception => e
      notice = e.message

    else
      notice = 'all Traffics were successfully destroyed.'

    end

    respond_to do |format|
      format.html { redirect_to traffics_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_traffic
    @traffic = Traffic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def traffic_params
    params.require(:traffic).permit(:statistic_selected, :count_visits_per_day, :hourly_daily_distribution, :percent_new_visit, :visit_bounce_rate, :avg_time_on_site, :statistic_type, :page_views_per_visit, :website_id, :statistic_id, :monday_start, :count_weeks, :change_count_visits_percent, :change_bounce_visits_percent, :direct_medium_percent, :organic_medium_percent, :referral_medium_percent, :advertising_percent, :advertisers, :max_duration_scraping, :min_count_page_advertiser, :max_count_page_advertiser, :min_duration_page_advertiser, :max_duration_page_advertiser, :percent_local_page_advertiser, :duration_referral, :min_count_page_organic, :max_count_page_organic, :min_duration_page_organic, :max_duration_page_organic, :min_duration, :max_duration, :min_duration_website, :min_pages_website)
  end

end

def render_after_create_or_update(ok, notice)
  respond_to do |format|
    if ok
      if params[:commit] == "Later"
        format.html { redirect_to traffics_path, notice: notice }

      end

      if params[:commit] == "Now"
        begin
          Publication::publish(@traffic.to_hash)

        rescue Exception => e
          format.html { redirect_to traffics_path, notice: "Traffic was not published : #{e.message}" }

        else
          @traffic.update_attribute(:state, :published)
          format.html { redirect_to traffics_path, notice: 'Traffic was successfully published to enginebot.' }

        end
      end
    else

      format.html {
        @websites = Website.all
        @statistics = Statistic.all
        @website = @traffic.website
        @statistic = @traffic.custom_statistic if @traffic.statistic_type == "custom"
        render :new
      }
      format.json { render json: @traffic.errors, status: :unprocessable_entity }

    end
  end
end