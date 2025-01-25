class HomeController < ApplicationController
  def dashboard
    @total_teachers = User.all_teachers.count
    @total_students = Student.all.count
    @total_subjects = Subject.all.count
    @current_semester = find_current_semester(Semester)
  end

  def subject_performance
    # Group reports by subject_id and calculate the average total score for each subject
    @subject_scores = Report.group(:subject_id)
                            .average(:total)
                            .transform_keys { |subject_id| Subject.find(subject_id).name }  # Get subject names

    # Define the threshold for passing
    passing_threshold = 50.0  # 50% is passing
    @subject_status = @subject_scores.transform_values do |score|
      score >= passing_threshold ? 'Progressing' : 'Failing'
    end
  end


  def find_current_semester(semester)
    unless semester.nil?
      today = Date.today
      current_year = today.beginning_of_year.strftime("%Y-%m-%d")
      current_term = today.month <= 6 ? 1 : 2 || today.month <= 8 ? 3 : 4
      current_semester = semester.find_by(year: current_year, term: current_term)
      
      year = current_semester.year.year
      term = current_semester.term
      "#{year} Term #{term}"
    else
      "Add semseter"
    end
  end  
end
