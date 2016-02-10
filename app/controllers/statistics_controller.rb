class StatisticsController < ApplicationController
  before_action :set_statistic, only: [:show, :edit, :update, :destroy]

  # GET /statistics
  # GET /statistics.json
  def index
    @statistics = Statistic.all
  end

  # GET /statistics/1
  # GET /statistics/1.json
  def show
  end

  # GET /statistics/new
  def new
    @statistic = Statistic.new
  end

  # GET /statistics/1/edit
  def edit
    @statistic = Statistic.find(params[:id])
  end

  # POST /statistics
  # POST /statistics.json
  def create
    @statistic = Statistic.new(statistic_params)

    respond_to do |format|
      if @statistic.save
        format.html { redirect_to statistics_path, notice: 'Statistic was successfully created.' }
        format.json { render :show, status: :created, location: @statistic }
      else
        format.html { render :new }
        format.json { render json: @statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statistics/1
  # PATCH/PUT /statistics/1.json
  def update
    respond_to do |format|
      if @statistic.update(statistic_params)
        format.html { redirect_to statistics_path, notice: 'Statistic was successfully updated.' }
        format.json { render :show, status: :ok, location: @statistic }
      else
        format.html { render :edit }
        format.json { render json: @statistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics/1
  # DELETE /statistics/1.json
  def destroy
    @statistic.destroy
    respond_to do |format|
      format.html { redirect_to statistics_url, notice: 'Statistic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Statistic.delete_all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_statistic
    @statistic = Statistic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def statistic_params
    params.require(:statistic).permit(:label,
                                      :count_visits_per_day,
                                      :percent_new_visit,
                                      :visit_bounce_rate, :avg_time_on_site, :page_views_per_visit,
                                      :hourly_daily_distribution0,
                                      :hourly_daily_distribution1,
                                      :hourly_daily_distribution2,
                                      :hourly_daily_distribution3,
                                      :hourly_daily_distribution4,
                                      :hourly_daily_distribution5,
                                      :hourly_daily_distribution6,
                                      :hourly_daily_distribution7,
                                      :hourly_daily_distribution8,
                                      :hourly_daily_distribution9,
                                      :hourly_daily_distribution10,
                                      :hourly_daily_distribution11,
                                      :hourly_daily_distribution12,
                                      :hourly_daily_distribution13,
                                      :hourly_daily_distribution14,
                                      :hourly_daily_distribution15,
                                      :hourly_daily_distribution16,
                                      :hourly_daily_distribution17,
                                      :hourly_daily_distribution18,
                                      :hourly_daily_distribution19,
                                      :hourly_daily_distribution20,
                                      :hourly_daily_distribution21,
                                      :hourly_daily_distribution22,
                                      :hourly_daily_distribution23)



  end
end
