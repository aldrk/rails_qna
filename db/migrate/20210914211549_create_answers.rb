class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :question, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.boolean :best, null: false, default: false


      t.timestamps
    end
  end
end
