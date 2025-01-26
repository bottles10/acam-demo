class Cutoff < ApplicationRecord
  belongs_to :school, default: -> { Current.school }
  validates :current_basic, presence: true, uniqueness: true
  validates :class_percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :exam_percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

end
