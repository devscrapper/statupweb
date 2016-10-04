class LogsController < ApplicationController
  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_log, only: [:show, :edit, :destroy, :update]

  def create
    @log = Log.new

    respond_to do |format|
      begin
        visit_id = Visit.find_by_id_visit(params['visit_id']).id
        @log.visit_id= visit_id

        unless params['file'].nil?
          uploaded_io = params['file']
          @log.log_file_id = "#{params['visit_id']}#{File.extname(uploaded_io.original_filename)}"
        end
        # save to DB
        @log.save!

        # save log to /public
        File.open(Rails.root.join('public', 'logs', @log.log_file_id), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end


      rescue Exception => e
        logger.debug e.message

        format.json { render json: e.message, status: :unprocessable_entity }

      else
        format.json { render json: @log, status: :created }

      end
    end
  end

  def show
    render file: File.join("public", "logs",@log.log_file_id)
  end
  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_log
    @log = Log.find_by_visit_id(params[:visit_id]) unless params[:visit_id].nil?
    @log = Log.find(params[:id]) unless params[:id].nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:log,
                                    :visit_id)
  end
end
