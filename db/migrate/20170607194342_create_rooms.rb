class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.integer :suap_id
      t.integer :year
      t.integer :semester
      t.string :curricular_component
      t.string :title

      t.timestamps
    end
  end
end
