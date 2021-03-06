require_relative '../../lib/publication'


class TrafficsController < ApplicationController
  before_action :set_traffic, only: [:show, :edit, :update, :destroy]
  include Publication

  # GET /traffics
  # GET /traffics.json
  def index
    @traffics = Traffic.order(:state, monday_start: :desc)
    @traffics.each { |traffic|
      if traffic.state == "published"
        begin
          traffic.planed_dates = Calendar.planed_dates(30, :traffic, traffic.id)
        rescue Exception => e
          traffic.planed_dates = []

        end
      else
        traffic.planed_dates = []
      end
    }
  end

  # GET /traffics/1
  # GET /traffics/1.json
  def show
    if @traffic.state == "published"
      begin
        @traffic.planed_dates = Calendar.planed_dates(30, :traffic, @traffic.id)
      rescue Exception => e
        @traffic.planed_dates = []

      end
    else
      @traffic.planed_dates = []
    end
  end

  # GET /traffics/new
  def new
    @websites = Website.all
    @statistics = Statistic.all
    @traffic = Traffic.new
    @traffic.advertising_percent =0
    @traffic.change_bounce_visits_percent= 1
    @traffic.change_count_visits_percent=100
    @traffic.count_weeks=1
    @traffic.direct_medium_percent=100
    @traffic.statistic_type="default"
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
    params[:traffic][:count_weeks] = params[:count_weeks_selected]
    @traffic = Traffic.new(traffic_params)
    begin
      @traffic.save!
    rescue Exception => e
      respond_to do |format|
        format.html {
          @websites = Website.all
          @statistics = Statistic.all
          @website = @traffic.website
          redirect_to new_traffic_path, alert: e.message and return
        }
      end
    end
    if @traffic.statistic_type == "custom"
      begin
        @statistic = @traffic.create_custom_statistic!({:statistic_id => params[:statistic_selected],
                                                        :policy_id => @traffic.id,
                                                        :policy_type => @traffic.class.name})
      rescue Exception => e
        # on remet le type par defaut et on le sauve car si l'utilisateur s'en va san terminer la creation alors il manque une custom static et cela entraineenra une erruer dans index
        @traffic.update_attribute(:statistic_type, "default")

        respond_to do |format|
          format.html {
            @websites = Website.all
            @statistics = Statistic.all
            @website = @traffic.website
            @traffic.monday_start = Traffic.next_monday(Date.today + @traffic.max_duration_scraping)
            redirect_to edit_traffic_path(@traffic), alert: e.message and return
          }
        end
      end

    end


    render_after_create_ok_or_update_ok("Traffic n°#{@traffic.id} was successfully created.")
  end

  def manual
    update_execution_mode("manual")
  end

  def auto
    update_execution_mode("auto")
  end

  def publish


    respond_to do |format|
      begin
        @traffic = Traffic.find(params[:id])

        raise "monday start is older" if @traffic.monday_start < Date.today
        Publication::publish(@traffic.to_hash)

      rescue Exception => e

        format.html { redirect_to traffics_path, alert: "Traffic n°#{params[:id]} was not published : #{e.message}" }

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
    begin
      @traffic.update!(traffic_params)
    rescue Exception => e
      respond_to do |format|
        format.html {
          @websites = Website.all
          @statistics = Statistic.all
          @website = @traffic.website
          redirect_to edit_traffic_path(@traffic), alert: e.message and return
        }
      end
    end
    if @traffic.statistic_type == "custom"
      begin
        if (@statistic = @traffic.custom_statistic).nil?
          @statistic = @traffic.create_custom_statistic!({:statistic_id => params[:statistic_selected],
                                                          :policy_id => @traffic.id,
                                                          :policy_type => @traffic.class.name})
        else
          @statistic.update_attributes!({:statistic_id => params[:statistic_selected]})
        end
      rescue Exception => e
        # on remet le type par defaut et on le sauve car si l'utilisateur s'en va san terminer la creation alors il manque une custom static et cela entraineenra une erruer dans index
        @traffic.update_attribute(:statistic_type, "default")

        respond_to do |format|
          format.html {
            @websites = Website.all
            @statistics = Statistic.all
            @website = @traffic.website
            @traffic.monday_start = Traffic.next_monday(Date.today + @traffic.max_duration_scraping)
            redirect_to edit_traffic_path(@traffic), alert: e.message and return
          }
        end
      end

    else # statistic_type = ga ou default
      @traffic.custom_statistic.delete unless @traffic.custom_statistic.nil?
    end

    render_after_create_ok_or_update_ok("Traffic n°#{@traffic.id} was successfully update.")
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

    notice = ""
    count_success = 0
    Traffic.all.each { |traffic|
      begin
        traffic.destroy

      rescue Exception => e
        notice += e.message
        notice += "\n"
      else
        count_success += 1

      end
    }
    notice += "#{count_success} Traffic(s) were successfully destroyed."

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
    params.require(:traffic).permit(:statistic_selected,
                                    :count_visits_per_day,
                                    :hourly_daily_distribution,
                                    :percent_new_visit,
                                    :visit_bounce_rate,
                                    :avg_time_on_site,
                                    :statistic_type,
                                    :page_views_per_visit,
                                    :website_id,
                                    :statistic_id,
                                    :monday_start,
                                    :count_weeks,
                                    :change_count_visits_percent,
                                    :change_bounce_visits_percent,
                                    :direct_medium_percent,
                                    :organic_medium_percent,
                                    :referral_medium_percent,
                                    :advertising_percent,
                                    :advertisers,
                                    :max_duration_scraping,
                                    :min_count_page_advertiser,
                                    :max_count_page_advertiser,
                                    :min_duration_page_advertiser,
                                    :max_duration_page_advertiser,
                                    :percent_local_page_advertiser,
                                    :duration_referral,
                                    :min_count_page_organic,
                                    :max_count_page_organic,
                                    :min_duration_page_organic,
                                    :max_duration_page_organic,
                                    :min_duration,
                                    :max_duration,
                                    :min_duration_website,
                                    :min_pages_website,
                                    :execution_mode)
  end

end

def update_execution_mode(mode)
  respond_to do |format|
    begin
      @traffic = Traffic.find(params[:id])

      if @traffic.state == "published"
        Publication::execution_mode("traffic", @traffic.id, mode)
      end

    rescue Exception => e

      format.html { redirect_to traffics_path, alert: "Execution mode Traffic n°#{params[:id]}  not change : #{e.message}" }

    else
      @traffic.update_attribute(:execution_mode, mode)
      format.html { redirect_to traffics_path, notice: 'Execution mode Traffic was successfully change to enginebot.' }

    end
  end
end

def render_after_create_ok_or_update_ok(notice)
  respond_to do |format|
    if params[:commit] == "Later"
      format.html { redirect_to traffics_path, notice: notice }

    end

    if params[:commit] == "Now"
      begin
        Publication::publish(@traffic.to_hash)

      rescue Exception => e
        format.html { redirect_to traffics_path, alert: "Traffic was not published : #{e.message}" }

      else
        @traffic.update_attribute(:state, :published)
        format.html { redirect_to traffics_path, notice: 'Traffic was successfully published to enginebot.' }

      end
    end


  end
end