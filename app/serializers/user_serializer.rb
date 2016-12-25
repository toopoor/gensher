class UserSerializer < ActiveModel::Serializer
  attributes :id, :avatar

  def avatar
    {
        source:{
            url: object.avatar.source.url,
            w:   object.avatar.source.width,
            h:   object.avatar.source.height,
            thumb: {
                url: object.avatar.source.thumb.url,
                w:   object.avatar.source.thumb.width,
                h:   object.avatar.source.thumb.height
            },
            icon:{
                url:  object.avatar.source.icon.url,
                w:    object.avatar.source.icon.width,
                h:    object.avatar.source.icon.height
            }
        }
    }
  end
end
