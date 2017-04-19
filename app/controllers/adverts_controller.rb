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
    Advert.select(:monday_start, :count_weeks).order('monday_start desc').each { |d|
      dates << d[:monday_start] + d[:count_weeks].to_i * 7
    }
    date = dates.sort!{|a,b| b<=>a}[0]

        if date <= Date.today
    @advert.monday_start = Date.today + @advert.max_duration_scraping

  else
    @advert.monday_start = date  + 1

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
  @advert.statistic_type = "custom"
  ok = @advert.update(advert_params)
  if ok and @advert.statistic_type == "custom"

    unless @statistic = @advert.custom_statistic
      @statistic = @advert.build_custom_statistic({:statistic_id => params[:statistic_selected]})

      ok = ok && @statistic.save!

    else
      @statistic.update_attribute(:statistic_id, params[:statistic_selected])

    end

  else


  end
  render_after_create_or_update(ok, "Advert n°#{@advert.id} was successfully update.")
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