class ReportsController < ApplicationController
  before_action :authenticate_ferrum_session
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :set_student

  def index
    @semester = params[:semester_id].present? ? @current_school.semesters.find(params[:semester_id]) : @current_school.semesters.order(year: :desc, term: :desc).first
    @reports = @semester ? @student.reports.by_semester(@semester.id).includes(:subject) : @student.reports.includes(:subject)
    @new_assessment = @semester.assessments.find_or_initialize_by(student: @student) || @semester.assessments.build(student: @student)
    
    @semester_id = @semester.id
    
    respond_to do |format|
      format.html
      format.pdf do 
        tmp = Tempfile.new
        browser = Ferrum::Browser.new(process_timeout: 30, timeout: 200, pending_connection_errors: true)
        page = browser.create_page
        page.headers.set("X-Ferrum-Session" => Rails.application.credentials.dig(:ferrum_session_token))
        page.go_to(student_reports_url(@student))
        sleep(0.3)
        page.pdf(path: tmp)
        browser.quit
        send_file tmp, type: "application/pdf", disposition: "inline"
      end
    end
  end
  
  def show
    
  end

  def new
    @report = @student.reports.new
    @subjects = @current_school.subjects
    @semesters = @current_school.semesters
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
    @subjects = @current_school.subjects
    @semesters = @current_school.semesters
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


  def authenticate_ferrum_session
    if request.headers["X-Ferrum-Session"].present?
      user = User.find_by(ferrum_session_token: request.headers["X-Ferrum-Session"])
      sign_in(user) if user
    else
      authenticate_user!
    end
  end

  def set_student
    @student = @current_school.students.find(params.expect(:student_id))
  end

  def set_report
    @report = Report.find(params.expect(:id))
  end

  def report_params
    params.expect(report: [ :exam_score, :subject_id, :student_id, :semester_id, :class_scores ] )
  end
end
