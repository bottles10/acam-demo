class SemestersController < ApplicationController
  def index
    @semesters = Semester.semester_year_grouped.group_by(&:year)
  end

  def show
    @semester = Semester.find(params.expect(:id))
  end

  def new
    @semester = Semester.new
  end

  def create
    @semester = Semester.new(semester_params)

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
