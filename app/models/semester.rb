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

	def self.find_current_semester(school)
		return "Add semester" if school.semesters.blank?

		today = Date.today
		year_value = today.year
		term_value =
		case today.month
			when 1..4 then 1
			when 5..8 then 2
			else 3
		end

		current_semester = school.semesters.find do |sem|
			sem.year.year == year_value && sem.term == term_value
		end

		return "Semester not found" if current_semester.nil?

		"Term #{current_semester.term}, #{current_semester.year.year}"
	end

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
