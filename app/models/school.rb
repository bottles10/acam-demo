class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :semesters, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :cutoffs

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/, message: "must contain only letters, numbers, or hyphens" }

end
