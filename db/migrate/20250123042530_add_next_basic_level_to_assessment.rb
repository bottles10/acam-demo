class AddNextBasicLevelToAssessment < ActiveRecord::Migration[8.0]
  def change
    add_column :assessments, :next_basic_level, :integer
  end
end
