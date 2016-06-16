class SeasController < ApplicationController
  before_action :set_sea, only: [:show, :edit, :update, :destroy]

  # GET /seas
  # GET /seas.json
  def index
    @seas = Sea.all
  end

  # GET /seas/1
  # GET /seas/1.json
  def show
  end

  # GET /seas/new
  def new
    @sea = Sea.new

  end

  # GET /seas/1/edit
  def edit
  end

  # POST /seas
  # POST /seas.json
  def create
    @sea = Sea.new(sea_params)
    @sea.fqdn_advertisings = params[:fqdn_advertisings].split(",").map! { |label| label.strip }
    @sea.keywords = params[:keywords].split(",").map! { |keyword| keyword.strip }
    respond_to do |format|
      if @sea.save

        format.html { redirect_to seas_url, notice: "Sea #{@sea.label} was successfully created." }
        format.json { render :show, status: :created, location: @sea }
      else
        format.html { render :new }
        format.json { render json: @sea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seas/1
  # PATCH/PUT /seas/1.json
  def update
    params[:sea][:fqdn_advertisings] = params[:fqdn_advertisings].split(",").map { |label| label.strip }
    params[:sea][:keywords] = params[:keywords].split(",").map { |keyword| keyword.strip }
    respond_to do |format|

      if @sea.update(sea_params)
        format.html { redirect_to seas_url, notice: "Sea #{@sea.label} was successfully updated." }
        format.json { render :show, status: :ok, location: @sea }
      else
        format.html { render :edit }
        format.json { render json: @sea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seas/1
  # DELETE /seas/1.json
  def destroy
    @sea.destroy
    respond_to do |format|
      format.html { redirect_to seas_url, notice: 'Sea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Sea.delete_all
  end


  def publish
    respond_to do |format|
      begin
        @sea = Sea.find(params[:id])
        #il existe forcement une Sea_attack publié  :
        # le test est fait lors de lindex.html
        # le bton publish ne serait pas affiché
        @sea_attack = @sea.published
        Publication::sea(@sea_attack.id, @sea.keywords, @sea.fqdn_advertisings)


      rescue Exception => e
        format.html { redirect_to seas_path, alert: "Label advertising SeaAttack n°#{@sea_attack.id}  not change : #{e.message}" }

      else
        format.html { redirect_to seas_path, notice: 'Label advertising SeaAttack was successfully change to enginebot.' }

      end
    end
  end

  def render_after_create_ok_or_update_ok(notice)
    respond_to do |format|
      if params[:commit] == "Later"
        format.html { redirect_to seas_path, notice: notice }

      end

      if params[:commit] == "Now"
        begin
          @sea = Sea.find(params[:id])
          #il existe forcement une Sea_attack publié  :
          # le test est fait lors de lindex.html
          # le bton publish ne serait pas affiché
          @sea_attack = @sea.published
          Publication::sea(@sea_attack.id, @sea.keywords, @sea.fqdn_advertisings)


        rescue Exception => e
          format.html { redirect_to seas_path, alert: "Label advertising SeaAttack n°#{@sea_attack.id}  not change : #{e.message}" }

        else
          format.html { redirect_to seas_path, notice: 'Label advertising SeaAttack was successfully change to enginebot.' }

        end
      end


    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sea
    @sea = Sea.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sea_params
    params.require(:sea).permit(:label,
                                :advertiser,
                                :keywords => [],
                                :fqdn_advertisings => [])
  end
end
