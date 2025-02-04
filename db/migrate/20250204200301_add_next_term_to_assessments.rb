class AddNextTermToAssessments < ActiveRecord::Migration[8.0]
  def change
    add_column :assessments, :next_term, :date
  end
end
