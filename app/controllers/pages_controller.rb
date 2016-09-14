class PagesController < ApplicationController
  protect_from_forgery

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_page, only: [:show, :edit, :destroy, :update]

  def create
    @page = Page.new

    respond_to do |format|
      begin
        visit_id = Visit.find_by_id_visit(params['visit_id']).id
        @page.visit_id= visit_id
        @page.index = params['index']
        unless params['image'].nil?
          uploaded_io = params['image']
          @page.image_file_id = "#{params['visit_id']}_#{params['index']}#{File.extname(uploaded_io.original_filename)}"
        end
        # save to DB
        @page.save!

        # save image to /public
        File.open(Rails.root.join('public', 'images', @page.image_file_id), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end


      rescue Exception => e
        logger.debug e.message

        format.json { render json: e.message, status: :unprocessable_entity }

      else
        format.json { render json: @page, status: :created }

      end
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.require(:captcha).permit(:image,
                                    :visit_id,
                                    :action,
                                    :index)
  end
end
