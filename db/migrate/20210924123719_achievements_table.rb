class AchievementsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.string :description, null: false
      t.references :user
      t.references :question, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
