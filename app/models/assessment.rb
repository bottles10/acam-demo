class Assessment < ApplicationRecord
  belongs_to :student
  belongs_to :semester

  validates :attendance_present, :attendance_total, presence: true, numericality: { only_integer: true, allow_nil: true }
  validates :attitude, :conduct, :interest, presence: true, length: { maximum: 40 }
  validates :class_teacher_remarks, presence: true,  length: { maximum: 40 }
  validates :semester_id, uniqueness: { scope: [ :student_id ], message: "for this student already have assessment record."}

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
