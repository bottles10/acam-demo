module Schools
  class DashboardController < ApplicationController
    # before_action :require_school
    before_action :authenticate_user!

  def waiting_room
    if current_user.admin? || !current_user.subjects.blank?
      redirect_to students_path, alert: "You are not part of subject assign waiting list!"
    end
  end

  def index
    @total_teachers = @current_school.users.all_teachers.count
    @total_students = @current_school.students.count
    @total_subjects = @current_school.subjects.count
    @current_semester = find_current_semester(@current_school.semesters)
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


  def find_current_semester(semester)  
    today = Date.today
    current_year = today.beginning_of_year.strftime("%Y-%m-%d")
    
    # Determine the current term based on the month
    current_term = if today.month <= 6
                     1
                   elsif today.month <= 8
                     2
                   else
                     3
                   end
  
    current_semester = semester.find_by(year: current_year, term: current_term)
  
    if current_semester
      year = current_semester.year.year
      term = current_semester.term
      "#{year} Term #{term}"
    else
      "Add semester"
    end
  end
  

    private

    def require_school
      redirect_to root_url(subdomain: nil), allow_other_host: true, alert: 'School not found' unless @current_school
    end
  end
end
