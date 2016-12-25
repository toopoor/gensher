class ReviewDecorator < Draper::Decorator
  delegate_all
  def author_avatar
    object.author.avatar.url(:source, :preview)
  end

  def author_url
    return unless decorated_author.facebook_url
    h.content_tag(:small) do
      h.link_to(decorated_author.facebook_url, target: '_blank') do
        h.safe_join([h.content_tag(:span, decorated_author.short_name, class: 'users-name'),
                     decorated_author.position], ' - ')
      end
    end
  end

  protected

  def decorated_author
    object.author.decorate
  end
end
