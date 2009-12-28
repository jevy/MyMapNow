class CityWideItemFlag < ActiveRecord::Migration
  def self.up
  add_column :items, :city_wide, :boolean, {:default=>false}
  end

  def self.down
    remove_column :items, :city_wide
  end
end
