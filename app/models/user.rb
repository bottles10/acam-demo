class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	
	belongs_to :school, default: ->{ Current.school }
  has_many :subject_teachers, foreign_key: :teacher_id, dependent: :destroy
  has_many :subjects, through: :subject_teachers
  
  before_save :humanize_username
	before_create :set_default_role

	after_create :assign_admin_if_needed
	after_destroy :assign_admin_if_needed
  validates :school, presence: true
	validates :username, presence: true, 
						uniqueness: { case_sensitive: false }, 
						length: { minimum: 2 }

	enum :role, { admin: 0, teacher: 1 }

	scope :all_teachers, -> { where(role: :teacher) }
	
	def self.find_for_authentication(warden_conditions)
    where(school: Current.school).find_by(username: warden_conditions[:username])
  end

	private

	def humanize_username
		self.username = username.downcase
	end

	def set_default_role
		self.role ||= :teacher
	end

	def assign_admin_if_needed
		if User.count == 1
			User.first.update(role: :admin)
		end
	end
end
