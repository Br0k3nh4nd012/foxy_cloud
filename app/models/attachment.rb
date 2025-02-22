class Attachment < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :user
  has_one_attached :file

  ## VALIDATIONS ##
  # validates :file, size: { less_than: 1.gigabytes }
  validates :tag , uniqueness: true
  validates :file, presence: true

  ## CALLBACKS ##
  before_validation :populate_tag


  def populate_tag
    self.tag = TagService.generate
  end

  def object_size
    byte_size = file.byte_size
    if byte_size < 1.megabyte
      "#{(byte_size / 1.kilobyte.to_f).round(2)} KB"
    elsif byte_size < 1.gigabyte
      "#{(byte_size / 1.megabyte.to_f).round(2)} MB"
    else
      "#{(byte_size / 1.gigabyte.to_f).round(2)} GB"
    end
  end
end