require 'rails_helper'

RSpec.describe "AttachmentsControllers", type: :request do 
  let!(:user) { User.create(email_address: "test@mail.com", password: BCrypt::Password.create("password")) }
  let!(:session) { Session.create(user_id: user.id) }
  let!(:attachment) { Attachment.create(user: user, title: "title", description: "description", file: fixture_file_upload('test_file.txt', 'text/plain')) }

  before {
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
  }
  describe "GET /index" do
    it "returns a successful response" do
      get attachments_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns a successful response" do
      get attachment_path(attachment)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) { { title: "Test Attachment", file: fixture_file_upload('test_file.txt', 'text/plain') } }

    context "with valid parameters" do
      it "creates a new Attachment" do
        expect {
          post attachments_path, params: { attachment: valid_attributes }
        }.to change(Attachment, :count).by(1)
      end

      it "redirects to the index page" do
        post attachments_path, params: { attachment: valid_attributes }
        expect(response).to redirect_to(attachments_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Attachment" do
        expect {
          post attachments_path, params: { attachment: { title: "asdf" } }
        }.to change(Attachment, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post attachments_path, params: { attachment: { title: "asdf" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) { { title: "Updated Attachment" } }

    context "with valid parameters" do
      it "updates the requested attachment" do
        patch attachment_path(attachment), params: { attachment: new_attributes }
        attachment.reload
        expect(attachment.title).to eq("Updated Attachment")
      end

      it "redirects to the attachment" do
        patch attachment_path(attachment), params: { attachment: new_attributes }
        attachment.reload
        expect(response).to redirect_to(attachment)
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch attachment_path(attachment), params: { attachment: { title: "", file: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested attachment" do
      expect {
        delete attachment_path(attachment)
      }.to change(Attachment, :count).by(-1)
    end

    it "redirects to the attachments list" do
      delete attachment_path(attachment)
      expect(response).to redirect_to(attachments_url)
    end
  end

  describe "GET /access_file" do
    context "when the attachment exists" do
      it "returns a successful response" do
        get access_file_path(tag: attachment.tag)
        expect(response).to have_http_status(:success)
      end
  
      it "sends the file" do
        get access_file_path(tag: attachment.tag)
        expect(response.header['Content-Disposition']).to include("attachment")
      end
    end
  
    context "when the attachment does not exist" do
      it "redirects to the attachments list with an alert" do
        get access_file_path(tag: "nonexistent_tag")
        expect(response).to redirect_to(attachments_path)
        follow_redirect!
        expect(response.body).to include("Attachment not found.")
      end
    end
  end
  
end
