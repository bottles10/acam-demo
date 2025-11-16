class PriceTier < ApplicationRecord
  validates :min_students, :price, presence: true

  def self.for_student_count(count)
    PriceTier
      .where("min_students <= ? AND (max_students IS NULL OR max_students >= ?)", count, count)
      .order(:min_students)
      .first
  end
  def display_name
    if max_students.present?
      "#{min_students} - #{max_students} students (GHc#{price})"
    else
      "#{min_students}+ students ($#{price})"
    end
  end
end
