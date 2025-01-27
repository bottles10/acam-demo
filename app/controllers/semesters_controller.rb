class SemestersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin_authorized, except: %i[ index show ]
  def index
    @semesters = @current_school.semesters.semester_year_grouped.group_by(&:year)
  end

  def show
    @semester = @current_school.semesters.find(params.expect(:id))
  end

  def new
    @semester = @current_school.semesters.new
  end

  def create
    @semester = @current_school.semesters.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to semesters_path, notice: "Semester added successfully!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end 
  end


  private

    def semester_params
      params.expect(semester: [ :year, :term ])
    end
end
