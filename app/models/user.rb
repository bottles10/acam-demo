class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
	

	has_secure_token :ferrum_session_token # used when using the ferrum gem. just keeping it

	belongs_to :school, default: -> { Current.school }
  has_many :subject_teachers, foreign_key: :teacher_id, dependent: :destroy
  has_many :subjects, through: :subject_teachers
  
  before_save :humanize_username
	before_create :set_default_role

	after_create :assign_admin_if_needed
	after_commit :auto_assign_admin_when_none, on: :destroy
  validates :school, presence: true
	validates :username, presence: true, 
						uniqueness: { scope: :school_id, case_sensitive: false }, 
						length: { minimum: 2 }
	validates :email, presence: true,
                  uniqueness: { scope: :school_id, case_sensitive: false },
                  format: { with:  Devise.email_regexp }
	validates :first_name, :last_name, presence: true, length: { minimum: 2 }
	validates :role, presence: true, allow_nil: false

	enum :role, { admin: 0, teacher: 1 }

	scope :all_teachers, -> { where(role: :teacher) }
	
	def self.find_for_authentication(warden_conditions)
  	username = warden_conditions[:username].to_s.downcase
  	where(school: Current.school).where("LOWER(username) = ?", username).first
	end


	# Friendly url
	def to_param
    "#{id}-#{self.fullname.downcase.to_s[0...100]}".parameterize
  end
	
	def fullname
		"#{self.first_name + " " + self.last_name}".titleize
	end

	private

	def humanize_username
		self.username = username.downcase
	end

	def set_default_role
		self.role ||= :teacher
	end

	def assign_admin_if_needed
  	update(role: :admin) if school.users.count == 1
	end

	def auto_assign_admin_when_none
		remaining_users = school.users
  	return if remaining_users.empty?

		# If no admin exists, promote one
		unless remaining_users.exists?(role: :admin)
			remaining_users.first.update(role: :admin)
		end
	end

end
