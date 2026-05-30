class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :name, null: false
      t.date :birth_date
      t.string :phone
      t.string :email

      t.timestamps
    end

    add_index :patients, :name
  end
end
