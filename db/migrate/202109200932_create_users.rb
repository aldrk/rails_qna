class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
