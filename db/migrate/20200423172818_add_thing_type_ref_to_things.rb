class AddThingTypeRefToThings < ActiveRecord::Migration
  def change
    add_reference :things, :thing_type, index: true, foreign_key: true
  end
end
