class AddLatAndLngToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :lat, :decimal, :precision => 15, :scale => 12
    add_column :photos, :lon, :decimal, :precision => 15, :scale => 12
  end
end
