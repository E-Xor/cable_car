class CreateWheels < ActiveRecord::Migration[8.0]
  def change
    create_table :wheels do |t|
      t.integer :location
      t.float :angle_position

      t.timestamps
    end
  end
end
