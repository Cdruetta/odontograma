class CreateToothStates < ActiveRecord::Migration[7.2]
  def change
    create_table :tooth_states do |t|
      t.references :odontogram, null: false, foreign_key: true
      t.string :tooth_number, null: false
      t.string :face, null: false, default: "whole"
      t.string :state, null: false, default: "healthy"
      t.string :color

      t.timestamps
    end

    add_index :tooth_states, [:odontogram_id, :tooth_number, :face], unique: true, name: "idx_tooth_states_on_odonto_tooth_face"
  end
end
