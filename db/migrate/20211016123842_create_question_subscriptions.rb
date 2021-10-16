class CreateQuestionSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :question_subscriptions do |t|
      t.references :question, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
