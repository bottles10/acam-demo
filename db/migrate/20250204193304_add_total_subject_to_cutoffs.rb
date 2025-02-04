class AddTotalSubjectToCutoffs < ActiveRecord::Migration[8.0]
  def change
    add_column :cutoffs, :total_subject, :integer
  end
end
