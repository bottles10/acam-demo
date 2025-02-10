class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_grading_scale_and_semester
  before_action :set_report, only: %i[ edit update destroy ]
  before_action :set_student

  def index
    @semester = params[:semester_id].present? ? @current_school.semesters.find(params[:semester_id]) : @current_school.semesters.order(year: :desc, term: :desc).first
    @reports = @semester ? @student.reports.by_semester(@semester.id).includes(:subject) : @student.reports.includes(:subject)
    @new_assessment = @semester.assessments.find_or_initialize_by(student: @student) || @semester.assessments.build(student: @student)
    @billings = @student.billings.by_semester(@semester.id).includes(:student)
    
    @semester_id = @semester.id
    
    respond_to do |format|
    format.html
    format.pdf {
      pdf = render_pdf(
        pdf_options: {
                        scale: 1,
                        paper_height: 11.7,
                        margin_top: 0.02
                    }
      )
      send_data pdf, disposition: :inline, filename: "#{@student.fullname.parameterize}-#{@current_school.name.parameterize}.pdf"
    }
  end
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

  def check_grading_scale_and_semester
    @student = @current_school.students.find(params.expect(:student_id))
    puts "******** semesters: #{ @current_school.semesters.exists? } ********"
    puts "******** grading scale: #{ !@student.cutoff_percentage[:class_cutoff_percentage].zero? } ********"
    if !@current_school.semesters.exists? 
      flash[:alert] = "Add semester to continue..."
      redirect_to(request.referer) and return
    elsif @student.cutoff_percentage[:class_cutoff_percentage].zero? && @student.cutoff_percentage[:exam_cutoff_percentage].zero?
      flash[:alert] = "You need to add grade scale for student's class!" 
      redirect_to(request.referer) and return
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
