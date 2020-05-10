class ChangeUserImagetoImageId < ActiveRecord::Migration
  def up
  	remove_column :users, :image
  	add_reference :users, :image, index: true, foreign_key: true
  end
  def down
  	remove_column :users, :image
  	add_column :users, :image, :string
  end
end
