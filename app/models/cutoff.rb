class Cutoff < ApplicationRecord
  belongs_to :school, default: -> { Current.school }
  validates :current_basic, presence: true, uniqueness: {scope: [:school_id] }
  validates :class_percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :exam_percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :total_subject, presence: true, numericality: { greater_than: 0 }

	validate :check_sum_of_class_and_exam_cutoff


  private

  def check_sum_of_class_and_exam_cutoff
		if class_percentage.to_f + exam_percentage.to_f != 100
      errors.add(:base, "Class and Exam percentages must sum to 100%")
    end
  end

end
