class ChangeClassScoreInReports < ActiveRecord::Migration[8.0]
  def change
    remove_column :reports, :class_score, :integer
    add_column :reports, :class_scores, :string
  end
end
