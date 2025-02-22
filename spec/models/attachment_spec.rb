require 'rails_helper'
require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:user) { User.create(email_address: "test@example.com", password: "password") }
  let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.txt'), 'plain/text') }

  it "is valid with valid attributes" do
    attachment = Attachment.new(user: user, file: file)
    expect(attachment).to be_valid
  end

  it "is not valid without a file" do
    attachment = Attachment.new(user: user, file: nil)
    expect(attachment).to_not be_valid
  end

  it "is not valid with a duplicate tag" do
    allow(TagService).to receive(:generate).and_return("unique_tag")
    Attachment.create(user: user, file: file, tag: "unique_tag")
    attachment = Attachment.new(user: user, file: file, tag: "unique_tag")
    expect(attachment).to_not be_valid
  end

  it "generates a tag before validation" do
    allow(TagService).to receive(:generate).and_return("generated_tag")
    attachment = Attachment.new(user: user, file: file)
    attachment.valid?
    expect(attachment.tag).to eq("generated_tag")
  end

  it "returns the correct object size in KB" do
    allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(500.kilobytes)
    attachment = Attachment.new(user: user, file: file)
    expect(attachment.object_size).to eq("500.0 KB")
  end

  it "returns the correct object size in MB" do
    allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(2.megabytes)
    attachment = Attachment.new(user: user, file: file)
    expect(attachment.object_size).to eq("2.0 MB")
  end

  it "returns the correct object size in GB" do
    allow_any_instance_of(ActiveStorage::Blob).to receive(:byte_size).and_return(3.gigabytes)
    attachment = Attachment.new(user: user, file: file)
    expect(attachment.object_size).to eq("3.0 GB")
  end
end