class Report < ApplicationRecord
  belongs_to :school, default: -> { Current.school }
  belongs_to :student
  belongs_to :subject
  belongs_to :semester

  validates :class_scores, presence: true, allow_nil: false
  validates :exam_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: false

  validates :subject_id, uniqueness: { scope: [:student_id, :semester_id], 
                                       message: "already has a report for this student and semester" }

  before_save :convert_class_scores_to_string
  before_save :adjust_exam_score
  before_save :cal_total_score_grade_and_remarks

  scope :by_semester, ->(semester) { where(semester_id: semester) }


  # Convert the class_scores string input into an array of decimals
  def parsed_class_scores
    sanitized_scores = class_scores.gsub(/[^0-9.,]/, '')
    sanitized_scores.split(',').map(&:strip).map(&:to_f)
  end

  def class_score_percentage_cutoff_result
    puts "******* Cuttof percentage: #{student.cutoff_percentage}"
    cutoff_percentages = student.cutoff_percentage
    class_percentage = cutoff_percentages[:class_cutoff_percentage].to_f / 100
    puts "class percentage in decimals: #{class_percentage}"
    total_class_score = parsed_class_scores.sum
    puts "total class score: #{total_class_score}"
    (total_class_score * class_percentage).round
  end

  def exam_score_percentage_cutoff_result
    cutoff_percentages = student.cutoff_percentage
    exam_percentage = cutoff_percentages[:exam_cutoff_percentage].to_f / 100
    (exam_score * exam_percentage).round
  end

  def convert_class_scores_to_string
    self.class_scores = class_score_percentage_cutoff_result.to_s
  end

  def adjust_exam_score
    self.exam_score = exam_score_percentage_cutoff_result
  end


  private


  def cal_total_score_grade_and_remarks
		self.total = (class_scores.to_f + exam_score).round
	
		self.grade = case total.ceil
								 when 90..100 then 1
								 when 80..89 then 2
								 when 70..79 then 3
								 when 60..69 then 4
								 when 55..59 then 5
								 when 50..54 then 6
								 when 40..49 then 7
								 when 35..39 then 8
								 else 9
								 end
	
		self.remarks = case grade
									 when 1 then 'Excellent'
									 when 2 then 'Very Good'
									 when 3 then 'Good'
									 when 4..6 then 'Credit'
									 when 7..8 then 'Pass'
									 else 'Fail'
									 end
	end
	
end
