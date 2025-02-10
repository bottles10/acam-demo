class Semester < ApplicationRecord
	belongs_to :school, default: -> { Current.school }
  has_many :reports, dependent: :destroy
	has_many :assessments, dependent: :destroy
	has_many :billings, dependent: :destroy

  validates :year, presence: true
  validates :term, presence: true, inclusion: { in: [1, 2, 3, 4] }
  validate :check_semester
	validate :check_current_year

	scope :semester_year_grouped, -> { order(year: :desc)}

  private

  def check_semester
		if Semester.exists?(year: self.year, term: self.term )
			errors.add(:base, 'This semester already exists!')
		end
	end  
	
	def check_current_year
		if self.year.year > Date.current.year
			errors.add(:base, 'Cannot set year later than current year!')
		end
	end
end
