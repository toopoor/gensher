class DocumentDecorator < Draper::Decorator
  delegate_all

  def thumb
    h.image_tag(h.document_path(object, size: 'thumb'), class: 'img-thumbnail', style: 'width: 200px; height: 200px')
  end

end
