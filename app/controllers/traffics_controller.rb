require 'publication'

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

  end

  # GET /traffics/1/edit
  def edit
  end

  # POST /traffics
  # POST /traffics.json
  def create

    #creation d'un nouveau website
    if params[:website_selected].empty?
      Website.create(label: params[:website_label]) do |w|
        w.profil_id_ga = params[:profil_id_ga]
        w.url_root = params[:url_root]
        w.count_page = params[:count_page]
        w.schemes = params[:schemes]
        w.types = params[:types]
        w.advertisers = params[:advertisers]
      end
      #recuperation de l'id du nouveau website
      params[:traffic][:website_id] = Website.find_by_label(params[:website_label]).id

    else
      #recuperation de l'id du website selectionné
      params[:traffic][:website_id] = params[:website_selected]
    end

    @traffic = Traffic.create(traffic_params)

    # selection d'une stats customisée
    if @traffic.statistic_type == "custom"

      # creation d'un enouvelle stats custom
      if params[:statistic_selected].empty?
        Statistic.create(label: params[:label]) do |s|
          s.count_visits_per_day = params[:count_visits_per_day]
          s.hourly_daily_distribution0 = params[:hourly_daily_distribution0]
          s.hourly_daily_distribution1 = params[:hourly_daily_distribution1]
          s.hourly_daily_distribution2 = params[:hourly_daily_distribution2]
          s.hourly_daily_distribution3 = params[:hourly_daily_distribution3]
          s.hourly_daily_distribution4 = params[:hourly_daily_distribution4]
          s.hourly_daily_distribution5 = params[:hourly_daily_distribution5]
          s.hourly_daily_distribution6 = params[:hourly_daily_distribution6]
          s.hourly_daily_distribution7 = params[:hourly_daily_distribution7]
          s.hourly_daily_distribution8 = params[:hourly_daily_distribution8]
          s.hourly_daily_distribution9 = params[:hourly_daily_distribution9]
          s.hourly_daily_distribution10 = params[:hourly_daily_distribution10]
          s.hourly_daily_distribution11 = params[:hourly_daily_distribution11]
          s.hourly_daily_distribution12 = params[:hourly_daily_distribution12]
          s.hourly_daily_distribution13 = params[:hourly_daily_distribution13]
          s.hourly_daily_distribution14 = params[:hourly_daily_distribution14]
          s.hourly_daily_distribution15 = params[:hourly_daily_distribution15]
          s.hourly_daily_distribution16 = params[:hourly_daily_distribution16]
          s.hourly_daily_distribution17 = params[:hourly_daily_distribution17]
          s.hourly_daily_distribution18 = params[:hourly_daily_distribution18]
          s.hourly_daily_distribution19 = params[:hourly_daily_distribution19]
          s.hourly_daily_distribution20 = params[:hourly_daily_distribution20]
          s.hourly_daily_distribution21 = params[:hourly_daily_distribution21]
          s.hourly_daily_distribution22 = params[:hourly_daily_distribution22]
          s.hourly_daily_distribution23 = params[:hourly_daily_distribution23]
          s.percent_new_visit = params[:percent_new_visit]
          s.visit_bounce_rate = params[:visit_bounce_rate]
          s.avg_time_on_site = params[:avg_time_on_site]
          s.page_views_per_visit = params[:page_views_per_visit]
        end
        # recuperation de l'id de la nouvelle stats
        statistic_id = Statistic.find_by_label(params[:label]).id

      else
        # recuperation de l'id de statistic séléctionnée
        statistic_id = params[:statistic_selected]
      end

      #enregistrement de la stat custom utilisé par Traffic
      CustomStatistic.create(statistic_id: statistic_id) do |s|
        s.policy_type = "traffic"
        s.policy_id = @traffic.id
      end

    end


    respond_to do |format|
      if params[:commit] == "Later"
        if @traffic.save
          format.html { redirect_to traffics_path, notice: 'Traffic was successfully created.' }
        else
          format.html {
            @websites = Website.all
            @statistics = Statistic.all
            render :new
          }
          format.json { render json: @traffic.errors, status: :unprocessable_entity }
        end

      elsif params[:commit] == "Now"
        if @traffic.save
          begin
            Publication::publish(@traffic.to_json)

          rescue Exception => e
            format.html { redirect_to traffics_path, notice: "Traffic was not published : #{e.message}" }

          else
            @traffic.update_attribute(:state, :published)
            format.html { redirect_to traffics_path, notice: 'Traffic was successfully published on scraperbot and enginebot.' }

          end

        else
          format.html {
            @websites = Website.all
            @statistics = Statistic.all
            render :new
          }
          format.json { render json: @traffic.errors, status: :unprocessable_entity }

        end
      end
    end
  end

  def publish
    @traffic = Traffic.find(params[:id])

    respond_to do |format|
      begin

        Publication::publish(@traffic.to_json)

      rescue Exception => e
        format.html { redirect_to traffics_path, notice: "Traffic n°#{params[:id]} was not published : #{e.message}" }

      else
        @traffic.update_attribute(:state, :published)
        format.html { redirect_to traffics_path, notice: 'Traffic was successfully published on scraperbot and enginebot.' }

      end
    end
  end

  # PATCH/PUT /traffics/1
  # PATCH/PUT /traffics/1.json
  def update
    if params[:commit] == "Now"

    end
    respond_to do |format|
      if @traffic.update(traffic_params)
        format.html { redirect_to @traffic, notice: 'Traffic was successfully updated.' }
        format.json { render :show, status: :ok, location: @traffic }
      else
        format.html { render :edit }
        format.json { render json: @traffic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /traffics/1
  # DELETE /traffics/1.json
  def destroy
    @traffic.destroy
    respond_to do |format|
      format.html { redirect_to traffics_url, notice: 'Traffic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Traffic.delete_all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_traffic
    @traffic = Traffic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def traffic_params
    params.require(:traffic).permit(:statistic_selected, :label, :count_visits_per_day, :hourly_daily_distribution, :percent_new_visit, :visit_bounce_rate, :avg_time_on_site, :statistic_type, :page_views_per_visit, :website_id, :statistic_id, :monday_start, :count_weeks, :change_count_visits_percent, :change_bounce_visits_percent, :direct_medium_percent, :organic_medium_percent, :referral_medium_percent, :advertising_percent, :advertisers, :max_duration_scraping, :min_count_page_advertiser, :max_count_page_advertiser, :min_duration_page_advertiser, :max_duration_page_advertiser, :percent_local_page_advertiser, :duration_referral, :min_count_page_organic, :max_count_page_organic, :min_duration_page_organic, :max_duration_page_organic, :min_duration, :max_duration, :min_duration_website, :min_pages_website)
  end

end
