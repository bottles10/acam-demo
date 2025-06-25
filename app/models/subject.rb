class Subject < ApplicationRecord
  belongs_to :school, default: -> { Current.school }
  has_many :subject_teachers, dependent: :destroy
  has_many :teachers, through: :subject_teachers, source: :teacher
  has_many :reports
	has_many :students, through: :reports

  validates :subject_name, presence: true, uniqueness: { scope: :school_id, case_sensitive: false }

  before_save :normalize_subject_name

  # Method to find or create a subject and add teachers to its associations
  def self.find_or_create_with_teachers(attributes)
    subject_name = attributes[:subject_name].strip.humanize
    teacher_ids = attributes[:teacher_ids].reject(&:blank?).map(&:to_i)

    # Find or initialize the subject
    subject = Subject.find_or_initialize_by(subject_name: subject_name)

    # Add the new teachers to the existing ones without replacing
    subject.teacher_ids |= teacher_ids

    # Save the subject and return it
    subject.save
    subject
  end

   # Friendly url
   def to_param
    "#{id}-#{subject_name.downcase.to_s[0...100]}".parameterize
  end


  private

  def normalize_subject_name
    self.subject_name = subject_name.strip.humanize
  end
end
