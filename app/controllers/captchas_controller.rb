class CaptchasController < ApplicationController
  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_captcha, only: [:show, :edit, :destroy, :update]

  def create
    @captcha = Captcha.new

    respond_to do |format|
      begin
        visit_id = Visit.find_by_id_visit(params['visit_id']).id
        @captcha.visit_id= visit_id
        @captcha.index = params['index']
        @captcha.text = params['text'] unless params['text'].nil?
        unless params['image'].nil?
          uploaded_io = params['image']
          @captcha.image_file_id = "#{params['visit_id']}_#{params['index']}_captcha#{File.extname(uploaded_io.original_filename)}"
        end
        # save to DB
        @captcha.save!

        # save image to /public
        File.open(Rails.root.join('public', 'images', @captcha.image_file_id), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end


      rescue Exception => e
        logger.debug e.message

        format.json { render json: e.message, status: :unprocessable_entity }

      else
        format.json { render json: @captcha, status: :created }

      end
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_captcha
    @captcha = Captcha.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def captcha_params
    params.require(:captcha).permit(:image,
                                    :visit_id,
                                    :index,
                                    :text)
  end

end
