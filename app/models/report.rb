class Report < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :semester

  validates :class_score, presence: true,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 30 }, allow_nil: false
	validates :exam_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 70 }, allow_nil: false

	validates :subject_id, uniqueness: { scope: [:student_id, :semester_id], 
													message: "already has a report for this student and semester" }

	before_save :cal_total_score_grade_and_remarks

  scope :by_semester, ->(semester) { where(semester_id: semester) }

  private


  def cal_total_score_grade_and_remarks
    self.total = class_score + exam_score

    self.grade = case total
								when 90..100 then '1'
								when 80..89 then '2'
								when 70..79 then '3'
								when 60..69 then '4'
								else '5'
								end
		self.remarks = case grade
									when '1' then 'Excellent'
									when '2' then 'Very Good'
									when '3' then 'Above Average'
									when '4' then 'Good'
									else 'Fair'
									end
  end
end
