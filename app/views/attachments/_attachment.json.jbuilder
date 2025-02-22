json.extract! attachment, :id, :title, :description, :format, :size_in_mb, :file, :user_id, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
json.file url_for(attachment.file)
