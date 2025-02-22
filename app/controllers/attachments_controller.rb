class AttachmentsController < ApplicationController
  before_action :set_attachment, only: %i[ show edit update destroy ]
  before_action :user_access, only: %i[show update destroy]
  allow_unauthenticated_access only: [:access_file]

  # GET /attachments or /attachments.json
  def index
    @attachments = Attachment.where(user_id: Current.user.id).all.includes(file_attachment: :blob)
  end

  # GET /attachments/1 or /attachments/1.json
  def show
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments or /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.user = Current.user
    
    respond_to do |format|
      if @attachment.save
        format.html { redirect_to attachments_path, notice: "Attachment was successfully created." }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1 or /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: "Attachment was successfully updated." }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1 or /attachments/1.json
  def destroy
    @attachment.destroy!

    respond_to do |format|
      format.html { redirect_to attachments_path, status: :see_other, notice: "Attachment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def access_file
    attachment = Attachment.find_by(tag: params[:tag])
    if attachment
      send_file ActiveStorage::Blob.service.path_for(attachment.file.key),
                stream: true,
                filename: attachment.file.filename.to_s,
                type: attachment.file.content_type,
                disposition: "attachment"
    else
      redirect_to attachments_path, alert: "Attachment not found."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find_by(id: params[:id])
      unless @attachment
        flash[:alert] = "Attachment not found!"
        redirect_to attachments_path and return
      end
    end

    def user_access
      return if @attachment.user_id == Current.user.id

      flash[:alert] = "Unauthorized Access"
      redirect_to attachments_path and return
    end

    # Only allow a list of trusted parameters through.
    def attachment_params
      params.require(:attachment).permit(:title, :description, :file, :user_id)
    end
end
