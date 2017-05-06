require_relative '../../lib/publication'


class AdvertsController < ApplicationController
  before_action :set_advert, only: [:show, :edit, :update, :show, :destroy]
  include Publication

  # GET /adverts
  # GET /adverts.json
  def index
    @adverts = Advert.order(:state, monday_start: :desc)
    @adverts.each { |advert|
      if advert.state == "published"
        begin
          advert.planed_dates = Calendar.planed_dates(30, :advert, advert.id)
        rescue Exception => e
          advert.planed_dates = []

        end
      else
        advert.planed_dates = []
      end
    }
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
    if @advert.state == "published"
      begin
        @advert.planed_dates = Calendar.planed_dates(30, :advert, @advert.id)
      rescue Exception => e
        @advert.planed_dates = []

      end
    else
      @advert.planed_dates = []
    end
  end

  # GET /adverts/new
  def new
    @websites = Website.all
    @statistics = Statistic.all
    @advert = Advert.new
    dates = []
    #TODO il manque le website dans la requete car en letat on n peut faire qu'une seule policy advert à la fois qq soit les sites
    Advert.select(:monday_start, :count_weeks).order('monday_start desc').each { |d|
      dates << d[:monday_start] + d[:count_weeks].to_i * 7
    }
    date = dates.sort! { |a, b| b<=>a }[0]

    if dates.empty? or date <= Date.today
      @advert.monday_start = Date.today + @advert.max_duration_scraping + 1

    else
      @advert.monday_start = date

    end

  end

  # GET /adverts/1/edit
  def edit
    @websites = Website.all
    @statistics = Statistic.all
    @advert = Advert.find(params[:id])
    @website = @advert.website
    @statistic = @advert.custom_statistic
    @advert.monday_start = Date.today + @advert.max_duration_scraping + 1 if @advert.monday_start - Date.today <= @advert.max_duration_scraping + 1
  end

  # POST /adverts
  # POST /adverts.json
  def create
    params[:advert][:website_id] = params[:website_selected]
    params[:advert][:count_weeks] = params[:count_weeks_selected]
    @advert = Advert.new(advert_params)
    @advert.statistic_type = "custom"
    ok = @advert.save
    if ok and @advert.statistic_type == "custom"
      @statistic = @advert.build_custom_statistic({:statistic_id => params[:statistic_selected]})
      ok = ok && @statistic.save
    end

    render_after_create_or_update(ok, "Advert n°#{@advert.id} was successfully created.")
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
        @advert = Advert.find(params[:id])

        raise "monday start is older" if @advert.monday_start < Date.today
        Publication::publish(@advert.to_hash)

      rescue Exception => e

        format.html { redirect_to adverts_path, alert: "Advert n°#{params[:id]} was not published : #{e.message}" }

      else
        @advert.update_attribute(:state, :published)
        format.html { redirect_to adverts_path, notice: 'Advert was successfully published to enginebot.' }

      end
    end
  end

  def unpublish
    @advert = Advert.find(params[:id])

    respond_to do |format|
      begin

        Publication::delete(@advert.id, Advert.name.downcase)

      rescue Exception => e

        format.html { redirect_to adverts_path, notice: "Advert n°#{params[:id]} was not unpublished : #{e.message}" }

      else
        @advert.update_attribute(:state, :created)
        @advert.tasks.destroy_all
        @advert.objectives.destroy_all
        @advert.visits.destroy_all
        format.html { redirect_to adverts_path, notice: 'Advert was successfully unpublished to enginebot.' }

      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
    params[:advert][:website_id] = params[:website_selected]
    params[:advert][:count_weeks] = params[:count_weeks_selected]
    @advert = Advert.find_by_id(params[:id])

    begin
      @advert.update!(advert_params)

    rescue Exception => e
      respond_to do |format|
             format.html {
               @websites = Website.all
               @statistics = Statistic.all
               @website = @advert.website
               redirect_to edit_advert_path(@advert), alert: e.message and return
             }
           end
    end
    begin
      if (@statistic = @advert.custom_statistic).nil?
        @statistic = @advert.create_custom_statistic!({:statistic_id => params[:statistic_selected],
                                                        :policy_id => @advert.id,
                                                        :policy_type => @advert.class.name})
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
          @website = @advert.website
          redirect_to edit_advert_path(@advert), alert: e.message and return
        }
      end
    end

    render_after_create_or_update(true, "Advert n°#{@advert.id} was successfully update.")
  end


  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    begin
      @advert.destroy

    rescue Exception => e
      notice = e.message
    else
      notice = 'Advert was successfully destroyed.'
    end

    respond_to do |format|
      format.html { redirect_to adverts_url, notice: notice }
      format.json { head :no_content }
    end
  end

  def destroy_all

    notice = ""
    count_success = 0
    Advert.all.each { |advert|
      begin
        advert.destroy

      rescue Exception => e
        notice += e.message
        notice += "\n"
      else
        count_success += 1

      end
    }
    notice += "#{count_success} Advert(s) were successfully destroyed."

    respond_to do |format|
      format.html { redirect_to adverts_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_advert
    @advert = Advert.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advert_params
    params.require(:advert).permit(:statistic_selected,
                                   :count_visits_per_day,
                                   :hourly_daily_distribution,
                                   :avg_time_on_site,
                                   :statistic_type,
                                   :page_views_per_visit,
                                   :website_id,
                                   :statistic_id,
                                   :monday_start,
                                   :count_weeks,
                                   :advertising_percent,
                                   :advertisers,
                                   :max_duration_scraping,
                                   :min_count_page_advertiser,
                                   :max_count_page_advertiser,
                                   :min_duration_page_advertiser,
                                   :max_duration_page_advertiser,
                                   :percent_local_page_advertiser,
                                   :min_duration,
                                   :max_duration,
                                   :min_duration_website,
                                   :min_pages_website,
                                   :execution_mode)
  end


  def update_execution_mode(mode)
    respond_to do |format|
      begin
        @advert = Advert.find(params[:id])

        if @advert.state == "published"
          Publication::execution_mode("advert", @advert.id, mode)
        end

      rescue Exception => e

        format.html { redirect_to adverts_path, alert: "Execution mode Advert n°#{params[:id]}  not change : #{e.message}" }

      else
        @advert.update_attribute(:execution_mode, mode)
        format.html { redirect_to adverts_path, notice: 'Execution mode Advert was successfully change to enginebot.' }

      end
    end
  end

  def render_after_create_or_update(ok, notice)
    respond_to do |format|
      if ok
        if params[:commit] == "Later"
          format.html { redirect_to adverts_path, notice: notice }

        end

        if params[:commit] == "Now"
          begin
            Publication::publish(@advert.to_hash)

          rescue Exception => e
            format.html { redirect_to adverts_path, alert: "Advert was not published : #{e.message}" }

          else
            @advert.update_attribute(:state, :published)
            format.html { redirect_to adverts_path, notice: 'Advert was successfully published to enginebot.' }

          end
        end
      else

        format.html {
          @websites = Website.all
          @statistics = Statistic.all
          @website = @advert.website
          @statistic = @advert.custom_statistic if @advert.statistic_type == "custom"
          render :new
        }
        format.json { render json: @advert.errors, status: :unprocessable_entity }

      end
    end
  end

end