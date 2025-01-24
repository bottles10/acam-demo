class ReportPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

   attr_reader :user, :report

  def initialize(user, report)
    @user = user
    @report = report
  end

  def create?
    teacher_assigned_to_subject?(report.subject_id)
  end

  def update?
    teacher_assigned_to_subject?(report.subject_id)
  end

  def destroy?
    teacher_assigned_to_subject?(report.subject_id)
  end

  private

  # Check if the teacher is assigned to the given subject
  def teacher_assigned_to_subject?(subject_id)
    return false if subject_id.nil? # Prevent errors when subject_id is missing
    user.teacher? && user.subjects.exists?(id: subject_id)
  end
  
  

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
