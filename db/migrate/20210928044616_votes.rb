class Votes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :votable, null: false, polymorphic: true
      t.index [:author_id, :votable_id], unique: true
      t.boolean :liked

      t.timestamps
    end
  end
end
