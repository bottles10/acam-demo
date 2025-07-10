class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # TODO: grading scale class score and exam score percentage sum should always equal 100%
  # TODO: Add head master's signature upload
  # TODO: update school root to students index.
  # TODO: make only admin access dashboard.
  # TODO: Finish updating tailwind syntax to version 4
  # TODO: Fix the global email to school id scope uniqueness in db level and user model
  # TODO: Create executive or  superAdmin page to manage schools, admin, etc
end
