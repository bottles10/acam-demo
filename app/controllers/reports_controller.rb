class ReportsController < ApplicationController
  before_action :set_report, only: %i[ edit update destroy ]
  before_action :set_student, only: %i[ index new create edit]

  def index
    @reports = @student.reports.includes(:subject, :semester)
  end

  def new
    @report = @student.reports.new
    @subjects = Subject.all
    @semesters = Semester.all
  end

  def create
    @report = @student.reports.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to student_reports_path(@student), notice: 'Report created succesffully! ' }
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
  end

  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to student_reports_path(@report.student), notice: "Report successfully updated!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy!
    redirect_to student_reports_path(@report.student), notice: "Report destroyed successfully!"
  end



  private

  def set_student
    @student = Student.find(params.expect(:student_id))
  end

  def set_report
    @report = Report.find(params.expect(:id))
  end

  def report_params
    params.expect(report: [ :class_score, :exam_score, :subject_id, :student_id, :semester_id] )
  end
end
