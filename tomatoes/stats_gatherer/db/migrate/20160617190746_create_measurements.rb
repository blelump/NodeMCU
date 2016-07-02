class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :sensor_id
      t.timestamp :measurement_time
      t.string :measurement_name
      t.float :value

      t.timestamps
    end

    add_index :measurements, [:sensor_id], name: "measurements_by_sensor_id"
    add_index :measurements, [:sensor_id, :measurement_name], name: "measurements_by_sensor_measurement_name"
  end
end
