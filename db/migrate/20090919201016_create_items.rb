class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.text :description
      t.datetime :begin_at
      t.datetime :end_at
      t.string :url
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :kind
      t.integer :created_by_id
      t.integer :approved_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
