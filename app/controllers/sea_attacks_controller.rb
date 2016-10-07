require_relative '../../lib/publication'

class SeaAttacksController < ApplicationController
  before_action :set_sea_attack, only: [:show, :edit, :update, :destroy]

  include Publication

  # GET /sea_attacks
  # GET /sea_attacks.json
  def index
    @sea_attacks = SeaAttack.order(:state)
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
    if @sea_attack.state == "published"
      begin
        @sea_attack.planed_dates = Calendar.planed_dates(30, :seaattack, @sea_attack.id)
      rescue Exception => e
        @sea_attack.planed_dates = []

      end
    else
      @sea_attack.planed_dates = []
    end
  end

  # GET /sea_attacks/new
  def new
    @seas = Sea.all
    @statistics = Statistic.all
    @sea_attack = SeaAttack.new
    @sea_attack.start_date = Date.today.next_day
  end

  # GET /sea_attacks/1/edit
  def edit
    @seas = Sea.all
    @statistics = Statistic.all
    @sea_attack = SeaAttack.find(params[:id])
    @sea = @sea_attack.sea
    @statistic = @sea_attack.custom_statistic if @sea_attack.statistic_type == "custom"
  end

  # POST /sea_attacks
  # POST /sea_attacks.json
  def create

    params[:sea_attack][:sea_id] = params[:sea_selected]
    @sea_attack = SeaAttack.new(sea_attack_params)
    begin
      @sea_attack.save!
    rescue Exception => e
      respond_to do |format|
        format.html {
          @seas = Sea.all
          @statistics = Statistic.all
          @sea = @sea_attack.sea
          redirect_to new_sea_attack_path(@sea_attack), alert: e.message and return
        }
      end
    end
    if @sea_attack.statistic_type == "custom"
      begin
        @statistic = @sea_attack.create_custom_statistic!({:statistic_id => params[:statistic_selected],
                                                           :policy_id => @sea_attack.id,
                                                           :policy_type => @sea_attack.class.name})
      rescue Exception => e
        # on remet le type par defaut et on le sauve car si l'utilisateur s'en va san terminer la creation alors il manque une custom static et cela entraineenra une erruer dans index
        @sea_attack.update_attribute(:statistic_type, "default")

        respond_to do |format|
          format.html {
            @seas = Sea.all
            @statistics = Statistic.all
            @sea = @sea_attack.sea
            redirect_to edit_sea_attack_path(@sea_attack), alert: e.message and return
          }
        end
      end

    end

    render_after_create_ok_or_update_ok("SeaAttack n°#{@sea_attack.id} was successfully created.")
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
        @sea_attack = SeaAttack.find(params[:id])

        raise "start date policy is older" if @sea_attack.start_date <= Date.today
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
    params[:sea_attack][:sea_id] = params[:sea_selected]
    params[:sea_attack][:start_date] = Date.parse(params[:sea_attack][:start_date])

    @sea_attack = SeaAttack.find_by_id(params[:id])

    begin
      @sea_attack.update!(sea_attack_params)

    rescue Exception => e
      respond_to do |format|
        format.html {
          @seas = Sea.all
          @statistics = Statistic.all
          @sea = @sea_attack.sea
          redirect_to edit_sea_attack_path(@sea_attack), alert: e.message and return
        }
      end
    end

    if @sea_attack.statistic_type == "custom"
      @statistic = @sea_attack.custom_statistic
      if  @statistic.nil?
        begin
          @statistic = @sea_attack.create_custom_statistic!({:statistic_id => params[:statistic_selected],
                                                             :policy_id => @sea_attack.id,
                                                             :policy_type => @sea_attack.class.name})
        rescue Exception => e
          # on remet le type par defaut et on le sauve car si l'utilisateur s'en va san terminer la creation alors il manque une custom static et cela entraineenra une erruer dans index
          @sea_attack.update_attribute(:statistic_type, "default")

          respond_to do |format|
            format.html {
              @seas = Sea.all
              @statistics = Statistic.all
              @sea = @sea_attack.sea
              redirect_to edit_sea_attack_path(@sea_attack), alert: e.message and return
            }
          end
        end

      else
        @statistic.update_attribute(:statistic_id, params[:statistic_selected])

      end

    end
    render_after_create_ok_or_update_ok("SeaAttack n°#{@sea_attack.id} was successfully update.")
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

  def update_execution_mode(mode)
    respond_to do |format|
      begin
        @sea_attack = SeaAttack.find(params[:id])

        if @sea_attack.state == "published"
          Publication::execution_mode("seaattack", @sea_attack.id, mode)
        end

      rescue Exception => e

        format.html { redirect_to sea_attacks_path, alert: "Execution mode SeaAttack n°#{params[:id]}  not change : #{e.message}" }

      else
        @sea_attack.update_attribute(:execution_mode, mode)
        format.html { redirect_to sea_attacks_path, notice: 'Execution mode SeaAttack was successfully change to enginebot.' }

      end
    end
  end

  def render_after_create_ok_or_update_ok(notice)
    respond_to do |format|
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


    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sea_attack
    @sea_attack = SeaAttack.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sea_attack_params
    params.require(:sea_attack).permit(:statistic_selected,
                                       :hourly_daily_distribution,
                                       :percent_new_visit,
                                       :visit_bounce_rate,
                                       :avg_time_on_site,
                                       :statistic_type,
                                       :page_views_per_visit,
                                       :sea_id,
                                       :statistic_id,
                                       :start_date,
                                       :count_weeks,
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
                                       :min_duration_sea,
                                       :min_pages_sea,
                                       :execution_mode)
  end

  private

end
