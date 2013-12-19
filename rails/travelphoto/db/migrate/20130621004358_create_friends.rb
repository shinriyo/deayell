class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :user
      t.references :following

      t.timestamps
    end
    add_index :friends, :user_id
    add_index :friends, :following_id
  end
end
