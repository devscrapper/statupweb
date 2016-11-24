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
          @page.image_file_id = "#{params['visit_id']}_#{params['index']}_screenshot#{File.extname(uploaded_io.original_filename)}"
        end
        # save image to /public
        File.open(Rails.root.join('public', 'images', @page.image_file_id), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end

        unless params['source'].nil?
          uploaded_io = params['source']
          @page.source_file_id = "#{params['visit_id']}_#{params['index']}_source#{File.extname(uploaded_io.original_filename)}"
        end

        # save source to /public
        File.open(Rails.root.join('public', 'sources', @page.source_file_id), 'wb') do |file|
          file.write(uploaded_io.read)
          file.close
        end

        # save to DB
        @page.save!


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

    @page = Page.find(params[:id]) if !params[:id].nil? and params[:visit_id].nil?
    @page = Page.find_by({:visit_id => params[:visit_id], :id => params[:id]}) if !params[:id].nil? and !params[:visit_id].nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.require(:page).permit(:image,
                                 :source,
                                 :visit_id,
                                 :index)
  end
end
