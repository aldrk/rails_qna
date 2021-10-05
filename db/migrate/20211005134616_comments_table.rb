class CommentsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :commentable, null: false, polymorphic: true
      t.string :body, null: false

      t.timestamps
    end
  end
end