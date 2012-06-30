class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.timestamps
      t.string :name
      t.string :description, :length => 255
      t.has_attached_file :photo
    end
  end
end
