class ActivityServersController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    @activity_servers = ActivityServer.all
  end

  def create
    if (@activity_server = ActivityServer.find_by_label(activity_server_params[:label])).nil?
      @activity_server = ActivityServer.new(activity_server_params)
      @activity_server.backtrace=activity_server_params[:backtrace]
      ok = @activity_server.save

    else
      ok = @activity_server.update(activity_server_params)

    end

    respond_to do |format|
      if ok
        format.json { render json: @activity_server, status: :created  }
      else

        format.json { render json: @activity_server.errors, status: :unprocessable_entity }

      end
    end
  end

  def update
    @activity_server = ActivityServer.find_by_id(params[:id])
    ok = @activity_server.update_attributes({:error_label => "",  :error_time => nil, :backtrace =>[""]})
    respond_to do |format|
      if ok
        format.html { redirect_to activity_servers_path, notice: 'activity update' }

      else

        format.html { redirect_to @activity_server.errors, status: :unprocessable_entity }

      end
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity_server
    @activity_server = ActivityServer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_server_params
    params.require(:activity_server).permit(:label,
                                            :hostname,
                                            :state,
                                            :error_label,
                                            :time,
                                            :error_time,
                                            :backtrace => [])
  end
end
