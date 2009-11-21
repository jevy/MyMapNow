class AddFacebookFieldsToUser < ActiveRecord::Migration
  def self.up
      add_column :users, :name, :string
      add_column :users, :facebook_uid, :integer, :limit => 8
      remove_column :users, :login
  end

  def self.down
    add_column :users, :login, :string
    remove_column :users, :facebook_uid
    remove_column :users, :name
  end
end
