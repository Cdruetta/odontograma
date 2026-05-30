class CreateOdontograms < ActiveRecord::Migration[7.2]
  def change
    create_table :odontograms do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :odontogram_type, null: false, default: "adult"
      t.integer :version, null: false, default: 1
      t.integer :user_id

      t.timestamps
    end

    add_index :odontograms, [:patient_id, :version], unique: true
  end
end
