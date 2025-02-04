class Student < ApplicationRecord
	belongs_to :school, default: -> { Current.school }
	has_many :reports
	has_many :subjects, through: :reports
	has_many :assessments
	
  validates :first_name, presence: true
	validates :last_name, presence: true
	validates :current_basic, presence: true


	enum :current_basic, { basic_one: 0, basic_two: 1, 
											basic_three: 2, basic_four: 3,
											basic_five: 4, basic_six: 5, 
											basic_seven: 6, basic_eight: 7, 
											basic_nine: 8 }
	
	
	# Friendly url
	def to_param
    "#{id}-#{self.fullname.downcase.to_s[0...100]}".parameterize
  end

	def fullname
		"#{self.first_name + " " + self.last_name}".titleize
	end

	 # Fetch the cutoff percentage for the student's current_basic
	 def cutoff_percentage
    cutoff = Cutoff.find_by(current_basic: self.current_basic)
    {
      class_cutoff_percentage: cutoff&.class_percentage || 0,
      exam_cutoff_percentage: cutoff&.exam_percentage || 0,
			total_subject: cutoff&.total_subject || 0
    }
  end
end
