class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :profile_id
      t.string :text
      t.timestamps
    end
  end
end
