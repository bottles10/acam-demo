class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # TODO: grading scale class score and exam score percentage sum should always equal 100%
  # TODO: Add head master's signature upload
  # TODO: update school root to students index. (Fixed with devise after_signed_in_for?)
  # TODO: make only admin access dashboard. (done)
  # TODO: Finish updating tailwind syntax to version 4 (done)
  # TODO: Fix the global email to school id scope uniqueness in db level and user model
  # TODO: Create executive or  superAdmin page to manage schools, admin, etc
  # TODO: When app is ready, clear nav to only show links authorized for teachers(eg: dashboard)
end
