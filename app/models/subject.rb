class Subject < ApplicationRecord
  has_many :subject_teachers
  has_many :teachers, through: :subject_teachers, source: :teacher
end
