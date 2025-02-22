class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.string :title
      t.text :description
      t.string :format
      t.integer :size_in_mb
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
