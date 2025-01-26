class AddSchoolIdToCutoffs < ActiveRecord::Migration[8.0]
  def change
    add_reference :cutoffs, :school, null: false, foreign_key: true
  end
end
