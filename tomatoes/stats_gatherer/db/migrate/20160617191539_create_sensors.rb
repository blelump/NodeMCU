class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :const_name
      t.string :name

      t.timestamps
    end
  end
end
