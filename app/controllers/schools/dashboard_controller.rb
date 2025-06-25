module Schools
  class DashboardController < ApplicationController
    # before_action :require_school
    before_action :authenticate_user!
    before_action :only_admin_authorized, only: %i[ update_role ]

  def waiting_room
    if current_user.admin? || !current_user.subjects.blank?
      redirect_to students_path, alert: "You are not part of subject assign waiting list!"
    end
  end

  def teachers
   @pagy, @teachers = pagy(@current_school.users.all_teachers, limit: 10)
  end

  def update_role
    @teacher = @current_school.users.all_teachers.find(params.expect(:id))
    if @teacher.update(role: params[:role])
      redirect_to teachers_path, notice: "Role updated successfully."
    else
      redirect_to teachers_path, alert: "Failed to update role."
    end
  end

  def index
    @total_teachers = @current_school.users.all_teachers.count
    @total_students = @current_school.students.count
    @total_subjects = @current_school.subjects.count
    @current_semester = Semester.find_current_semester(@current_school) # class method in semester model
    @reports = @current_school.reports.includes(:student, :subject).all.limit(10)

    subject_performance
  end

  def subject_performance
    # Aggregate reports across all semesters and calculate the average total score for each subject
    @subject_scores = @current_school.reports.joins(:semester)
                            .group(:subject_id, :semester_id)
                            .average(:total)
                            .map do |(subject_id, semester_id), avg_score|
                              subject_name = @current_school.subjects.find(subject_id).subject_name
                              semester_term = @current_school.semesters.find(semester_id).term
                              # Construct the label as "Subject - Term X"
                              ["#{subject_name} - Term #{semester_term}", avg_score]
                            end.to_h  # This is where the `.to_h` should come after the `map` block

    # Define the threshold for passing
    passing_threshold = 50.0  # 50% is passing
    @subject_status = @subject_scores.transform_values do |score|
      score >= passing_threshold ? 'Progressing' : 'Failing'
    end
  end


    private

    def require_school
      redirect_to root_url(subdomain: nil), allow_other_host: true, alert: 'School not found' unless @current_school
    end
  end
end
