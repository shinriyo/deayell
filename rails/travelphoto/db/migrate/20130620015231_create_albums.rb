class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.text :title
      t.references :travel

      t.timestamps
    end
    add_index :albums, :travel_id

  end
end
