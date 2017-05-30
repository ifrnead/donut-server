class AddSuapDataToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :suap_token, :string
    add_index :users, :suap_token, unique: true
    add_column :users, :suap_id, :integer
    add_column :users, :enroll_id, :integer
    add_column :users, :name, :string
    add_column :users, :fullname, :string
    add_column :users, :url_profile_pic, :string
    add_column :users, :category, :string
  end
end
