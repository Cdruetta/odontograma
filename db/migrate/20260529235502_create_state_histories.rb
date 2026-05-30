class CreateStateHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :state_histories do |t|
      t.references :odontogram, null: false, foreign_key: true
      t.references :tooth_state, null: false, foreign_key: true
      t.string :tooth_number, null: false
      t.string :face, null: false
      t.string :old_state
      t.string :new_state, null: false
      t.integer :user_id
      t.datetime :changed_at, null: false

      t.timestamps
    end

    add_index :state_histories, :changed_at
    add_index :state_histories, :user_id
  end
end
