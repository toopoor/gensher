class Document < ActiveRecord::Base
  belongs_to :user
  mount_uploader :file, DocumentUploader

end
