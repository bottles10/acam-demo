class Student < ApplicationRecord
  validates :first_name, presence: true
	validates :last_name, presence: true
	validates :current_basic, presence: true


	enum :current_basic, { basic_one: 0, basic_two: 1, 
											basic_three: 2, basic_four: 3,
											basic_five: 4, basic_six: 5, 
											basic_seven: 6, basic_eight: 7, 
											basic_nine: 8 }
	
	def fullname
		"#{self.first_name + " " + self.last_name}"
	end
end
