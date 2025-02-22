class AddTagToAttachment < ActiveRecord::Migration[8.0]
  def change
    return if column_exists?(:attachments, :tag)
    
    add_column :attachments, :tag, :string 
  end
end
