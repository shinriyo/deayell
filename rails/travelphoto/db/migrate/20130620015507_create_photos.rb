class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.text :comment
      t.references :user
      t.references :album

      t.timestamps
    end
    add_index :photos, :user_id
    add_index :photos, :album_id
  end
end
