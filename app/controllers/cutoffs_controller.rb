class CutoffsController < ApplicationController
  before_action :set_cutoff, only: %i[ show edit update destroy ]

  # GET /offcuts or /offcuts.json
  def index
    @cutoffs = Cutoff.all.order(created_at: :desc)
  end

  # GET /cutoffs/1 or /cutoffs/1.json
  def show
  end

  # GET /cutoffs/new
  def new
    @cutoff = Cutoff.new
  end

  # GET /cutoffs/1/edit
  def edit
  end

  # POST /cutoffs or /cutoffs.json
  def create
    @cutoff = Cutoff.new(cutoff_params)

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
      @cutoff = Cutoff.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cutoff_params
      params.expect(cutoff: [ :current_basic, :class_percentage, :exam_percentage ])
    end
end
