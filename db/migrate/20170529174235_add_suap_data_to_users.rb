class AddSuapDataToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_suap_token, :string
    add_column :users, :suap_token_expiration_time, :datetime
    add_index :users, :current_suap_token, unique: true
    add_column :users, :suap_id, :integer
    add_column :users, :enroll_id, :integer
    add_column :users, :name, :string
    add_column :users, :fullname, :string
    add_column :users, :url_profile_pic, :string
    add_column :users, :category, :string
    add_column :users, :token, :string
    add_index :users, :token, unique: true
  end
end
