class Subject < ApplicationRecord
  has_many :subject_teachers, dependent: :destroy
  has_many :teachers, through: :subject_teachers, source: :teacher

  validates :subject_name, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_subject_name


  def to_param
    "#{id}-#{subject_name.downcase.to_s[0...100]}".parameterize
  end


  private

  def normalize_subject_name
    self.subject_name = subject_name.strip.titleize
  end
end
