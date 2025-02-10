class Billing < ApplicationRecord
  belongs_to :student
  belongs_to :semester

  validates :title, presence: true
  validates :amount, presence: true

  before_save -> { self.title = title.titleize }
  scope :by_semester, ->(semester) { where(semester_id: semester) }

end
