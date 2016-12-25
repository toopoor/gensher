class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents/1
  def show
    document = current_user.admin? ? Document.find(params[:id]) : current_user.documents.find(params[:id])
    respond_to do |format|
      format.html {
        doucment_path = params[:size].eql?('thumb') ? document.file.thumb.path : document.file.path
        logger.info("Read document: #{doucment_path}")
        send_data( File.open(doucment_path).read, type: document.file.content_type, disposition: 'inline') }
    end
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
    @document.user = current_user
    respond_to do |format|
      if @document.save
        format.html { redirect_to edit_user_registration_path, notice: 'Document was successfully added.' }
      else
        format.html { redirect_to edit_user_registration_path, error: @document.errors.full_messages.join(', ') }
      end
    end
  end


  # DELETE /documents/1
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.js { }
    end
  end

  private
  def set_document
    @document = current_user.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:user_id, :file)
  end
end
