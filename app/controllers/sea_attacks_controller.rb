require_relative '../../lib/publication'

class SeaAttacksController < ApplicationController
  before_action :set_sea_attack, only: [:show, :edit, :update, :destroy]

  include Publication

  # GET /sea_attacks
  # GET /sea_attacks.json
  def index
    @sea_attacks = SeaAttack.all
    @sea_attacks.each { |sea_attack|
      if sea_attack.state == "published"
        begin
          sea_attack.planed_dates = Calendar.planed_dates(30, :seaattack, sea_attack.id)
        rescue Exception => e
          sea_attack.planed_dates = []

        end
      else
        sea_attack.planed_dates = []
      end
    }
  end

  # GET /sea_attacks/1
  # GET /sea_attacks/1.json
  def show

  end

  # GET /sea_attacks/new
  def new
    @websites = Website.all
    @statistics = Statistic.all
    @sea_attack = SeaAttack.new
    @sea_attack.monday_start = SeaAttack.next_monday(Date.today + @sea_attack.max_duration_scraping)
  end

  # GET /sea_attacks/1/edit
  def edit
    @websites = Website.all
    @statistics = Statistic.all
    @sea_attack = SeaAttack.find(params[:id])
    @website = @sea_attack.website
    @statistic = @sea_attack.custom_statistic if @sea_attack.statistic_type == "custom"
  end

  # POST /sea_attacks
  # POST /sea_attacks.json
  def create

    params[:sea_attack][:website_id] = params[:website_selected]
    @sea_attack = SeaAttack.new(sea_attack_params)
    ok = @sea_attack.save
    if ok and @sea_attack.statistic_type == "custom"
      @statistic = @sea_attack.build_custom_statistic({:statistic_id => params[:statistic_selected]})
      ok = ok && @statistic.save
    end

    render_after_create_or_update(ok, "SeaAttack n°#{@sea_attack.id} was successfully created.")
  end

  def publish


    respond_to do |format|
      begin
        @sea_attack = SeaAttack.find(params[:id])

        raise "monday start is older" if @sea_attack.monday_start < Date.today
        Publication::publish(@sea_attack.to_hash)

      rescue Exception => e

        format.html { redirect_to sea_attacks_path, alert: "SeaAttack n°#{params[:id]} was not published : #{e.message}" }

      else
        @sea_attack.update_attribute(:state, :published)
        format.html { redirect_to sea_attacks_path, notice: 'SeaAttack was successfully published to enginebot.' }

      end
    end
  end

  def unpublish
    @sea_attack = SeaAttack.find(params[:id])

    respond_to do |format|
      begin

        Publication::delete(@sea_attack.id, SeaAttack.name.downcase)

      rescue Exception => e

        format.html { redirect_to sea_attacks_path, notice: "SeaAttack n°#{params[:id]} was not unpublished : #{e.message}" }

      else
        @sea_attack.update_attribute(:state, :created)
        @sea_attack.tasks.destroy_all
        @sea_attack.objectives.destroy_all
        @sea_attack.visits.destroy_all
        format.html { redirect_to sea_attacks_path, notice: 'SeaAttack was successfully unpublished to enginebot.' }

      end
    end
  end

  # PATCH/PUT /sea_attacks/1
  # PATCH/PUT /sea_attacks/1.json
  def update
    params[:sea_attack][:website_id] = params[:website_selected]
    @sea_attack = SeaAttack.find_by_id(params[:id])
    ok = @sea_attack.update(sea_attack_params)
    if ok and @sea_attack.statistic_type == "custom"

      unless @statistic = @sea_attack.custom_statistic
        @statistic = @sea_attack.build_custom_statistic({:statistic_id => params[:statistic_selected]})
        ok = ok && @statistic.save

      else
        @statistic.update_attribute(:statistic_id, params[:statistic_selected])

      end

    else


    end
    render_after_create_or_update(ok, "SeaAttack n°#{@sea_attack.id} was successfully update.")
  end


  # DELETE /sea_attacks/1
  # DELETE /sea_attacks/1.json
  def destroy
    begin
      @sea_attack.destroy

    rescue Exception => e
      notice = e.message
    else
      notice = 'SeaAttack was successfully destroyed.'
    end

    respond_to do |format|
      format.html { redirect_to sea_attacks_url, notice: notice }
      format.json { head :no_content }
    end
  end

  def destroy_all

    begin
      SeaAttack.all.each { |sea_attack| sea_attack.destroy }

    rescue Exception => e
      notice = e.message

    else
      notice = 'all SeaAttacks were successfully destroyed.'

    end

    respond_to do |format|
      format.html { redirect_to sea_attacks_url, notice: notice }
      format.json { head :no_content }
    end
  end



  def render_after_create_or_update(ok, notice)
    respond_to do |format|
      if ok
        if params[:commit] == "Later"
          format.html { redirect_to sea_attacks_path, notice: notice }

        end

        if params[:commit] == "Now"
          begin
            Publication::publish(@sea_attack.to_hash)

          rescue Exception => e
            format.html { redirect_to sea_attacks_path, alert: "SeaAttack was not published : #{e.message}" }

          else
            @sea_attack.update_attribute(:state, :published)
            format.html { redirect_to sea_attacks_path, notice: 'SeaAttack was successfully published to enginebot.' }

          end
        end
      else

        format.html {
          @websites = Website.all
          @statistics = Statistic.all
          @website = @sea_attack.website
          @statistic = @sea_attack.custom_statistic if @sea_attack.statistic_type == "custom"
          render :new
        }
        format.json { render json: @sea_attack.errors, status: :unprocessable_entity }

      end
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_sea_attack
      @sea_attack = SeaAttack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sea_attack_params
      params.require(:sea_attack).permit(:statistic_selected,
                                         :count_visits_per_day,
                                         :keywords,
                                         :label_advertising,
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
                                         :count_visits_per_day,
                                         :max_duration_scraping,
                                         :min_count_page_advertiser,
                                         :max_count_page_advertiser,
                                         :min_duration_page_advertiser,
                                         :max_duration_page_advertiser,
                                         :percent_local_page_advertiser,
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

  private
end
