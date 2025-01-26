class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[ edit update destroy ]
  before_action :set_student, only: %i[ index new create edit update]

  def index
    @semester = params[:semester_id].present? ? Semester.find(params[:semester_id]) : Semester.order(year: :desc, term: :desc).first
    @reports = @semester ? @student.reports.by_semester(@semester.id).includes(:subject) : @student.reports.includes(:subject)
    @new_assessment = @semester.assessments.find_or_initialize_by(student: @student) || @semester.assessments.build(student: @student)
  end


  def new
    @report = @student.reports.new
    @subjects = Subject.all
    @semesters = Semester.all
  end

  def create
    @report = @student.reports.new(report_params)
    authorize @report

    respond_to do |format|
      if @report.save
        format.html { redirect_to student_reports_url(params[:student_id]) + "?semester_id=#{params[:report][:semester_id]}", notice: 'Report created successfully!' }
      else
        @subjects = Subject.all
        @semesters = Semester.all
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @subjects = Subject.all
    @semesters = Semester.all
    authorize @report
  end

  def update
    authorize @report
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to student_reports_url(params[:student_id]) + "?semester_id=#{params[:report][:semester_id]}", notice: 'Report updated successfully!' }
      else
        @subjects = Subject.all
        @semesters = Semester.all
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @report
    @report.destroy!
    
    respond_to do |format|
      format.html { redirect_to student_reports_url(params[:student_id]) + "?semester_id=#{:semester_id}", notice: 'Report destroyed successfully!' }
      format.json { head :no_content }
    end
  end



  private

  def set_student
    @student = Student.find(params.expect(:student_id))
  end

  def set_report
    @report = Report.find(params.expect(:id))
  end

  def report_params
    params.expect(report: [ :exam_score, :subject_id, :student_id, :semester_id, :class_scores ] )
  end
end
