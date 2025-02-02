class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :semesters, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :cutoffs, dependent: :destroy
  has_many :reports, dependent: :destroy
  
  has_one_attached :logo

  validates :logo, size: {less_than: 5.megabytes, message: "Must be less than 5MB."}
  validates :logo, content_type: ['image/png', 'image/jpeg']

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must contain only letters, numbers, or hyphens" }
  validates :phone_number, :email, :box_address, :motto, presence: true

  	# Friendly url
	def to_param
    "#{id}-#{self.subdomain.downcase.to_s[0...100]}".parameterize
  end
end
