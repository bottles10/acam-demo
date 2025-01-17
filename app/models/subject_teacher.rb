class SubjectTeacher < ApplicationRecord
  belongs_to :subject
  belongs_to :teacher, -> { where(role: :teacher) }, class_name: 'User'

  validates :teacher_id, uniqueness: { scope: :subject_id, message: ->(record, data) {
    teacher = User.teacher.find(record.teacher_id) # Fetch the teacher explicitly
    "#{teacher.username} is already assigned to this subject."
  } }
end
