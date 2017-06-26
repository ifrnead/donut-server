class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.belongs_to :user
      t.belongs_to :room

      t.timestamps
    end
  end
end
