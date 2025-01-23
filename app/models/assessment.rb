class Assessment < ApplicationRecord
  belongs_to :student
  belongs_to :semester

  validates :attendance_present, :attendance_total, presence: true, numericality: { only_integer: true, allow_nil: true }
  validates :attitude, :conduct, :interest, presence: true, length: { maximum: 40 }
  validates :class_teacher_remarks, presence: true,  length: { maximum: 40 }
  validates :semester_id, uniqueness: { scope: [ :student_id ], message: "for this student already have assessment record."}

  enum :next_basic_level, { basic_one: 0, basic_two: 1, 
											basic_three: 2, basic_four: 3,
											basic_five: 4, basic_six: 5, 
											basic_seven: 6, basic_eight: 7, 
											basic_nine: 8 }

  before_save :upcase_assessment_attributes

  private

  def upcase_assessment_attributes
    self.attitude = attitude.upcase
    self.conduct = conduct.upcase
    self.interest = interest.upcase
    self.class_teacher_remarks = class_teacher_remarks.upcase
    self.form_master = form_master.upcase
  end
end
