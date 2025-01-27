class CutoffsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cutoff, only: %i[ show edit update destroy ]
  before_action :only_admin_authorized, except: %i[ index show ]

  # GET /offcuts or /offcuts.json
  def index
    @cutoffs = @current_school.cutoffs.all.order(created_at: :desc)
  end

  # GET /cutoffs/1 or /cutoffs/1.json
  def show
  end

  # GET /cutoffs/new
  def new
    @cutoff = @current_school.cutoffs.new
  end

  # GET /cutoffs/1/edit
  def edit
  end

  # POST /cutoffs or /cutoffs.json
  def create
    @cutoff = @current_school.cutoffs.new(cutoff_params)

    respond_to do |format|
      if @cutoff.save
        format.html { redirect_to @cutoff, notice: "cutoff percentage successfully created." }
        format.json { render :show, status: :created, location: @cutoff }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cutoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cutoffs/1 or /cutoffs/1.json
  def update
    respond_to do |format|
      if @cutoff.update(cutoff_params)
        format.html { redirect_to @cutoff, notice: "cutoff percentage successfully updated." }
        format.json { render :show, status: :ok, location: @cutoff }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cutoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cutoffs/1 or /cutoffs/1.json
  def destroy
    @cutoff.destroy!

    respond_to do |format|
      format.html { redirect_to cutoffs_path, status: :see_other, notice: "cutoff percentage successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cutoff
      @cutoff = @current_school.cutoffs.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cutoff_params
      params.expect(cutoff: [ :current_basic, :class_percentage, :exam_percentage ])
    end
end
