class AddTagToAttachment < ActiveRecord::Migration[8.0]
  def change
    add_column :attachments, :tag, :string
  end
end
