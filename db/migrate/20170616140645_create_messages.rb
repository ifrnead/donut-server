class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :author_id
      t.belongs_to :receiver, polymorphic: true

      t.timestamps
    end
    add_index :messages, [:receiver_id, :receiver_type]
  end
end
