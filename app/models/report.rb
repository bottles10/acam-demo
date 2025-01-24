class Report < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :semester

  validates :class_scores, presence: true, allow_nil: false
  validates :exam_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: false

  validates :subject_id, uniqueness: { scope: [:student_id, :semester_id], 
                                       message: "already has a report for this student and semester" }

  before_save :convert_class_scores_to_string
  before_save :cal_total_score_grade_and_remarks

  scope :by_semester, ->(semester) { where(semester_id: semester) }

  private

  # Convert the class_scores string input into an array of decimals
  def parsed_class_scores
    sanitized_scores = class_scores.gsub(/[^0-9.,]/, '')
    sanitized_scores.split(',').map(&:strip).map(&:to_f)
  end

  def convert_class_scores_to_string
    self.class_scores = parsed_class_scores.sum.to_s
  end

  def thirty_percent_of_class_score
    total_class_score = parsed_class_scores.sum.round(2)

    total_class_score * 0.3
  end

  def cal_total_score_grade_and_remarks
		self.total = (thirty_percent_of_class_score + exam_score).round
	
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
