class User < ApplicationRecord
  has_many :subject_teachers, foreign_key: :teacher_id
  has_many :subjects, through: :subject_teachers
  
  before_save { username.downcase! }
	before_create :set_default_role

	after_create :assign_admin_if_needed
	after_destroy :assign_admin_if_needed
  
	validates :username, presence: true, 
						uniqueness: { case_sensitive: false }, 
						length: { minimum: 2 }

	enum :role, { admin: 0, teacher: 1 }

	scope :all_teachers, -> { where(role: :teacher) }

	private

	def set_default_role
		self.role ||= :teacher
	end

	def assign_admin_if_needed
		if User.count == 1
			User.first.update(role: :admin)
		end
	end
end
