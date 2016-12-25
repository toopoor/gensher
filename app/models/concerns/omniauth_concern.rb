module OmniauthConcern
  extend ActiveSupport::Concern

  included do
    DUMMY_PHONE = '+0(123)4'
    devise :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2, :linkedin, :vkontakte, :odnoklassniki]
    has_many :authentications, dependent: :destroy
  end

  module ClassMethods
    def connect_to_provider(provider, auth, parent, signed_in_resource=nil)
      user = signed_in_resource
      user ||= if (authentication = Authentication.find_by(provider: auth.provider, uid: auth.uid)).present?
                 authentication.user
               else
                 if (email = auth.recursive_find_by_key("email")).blank?
                   parent.children.build
                 else
                   parent.children.find_or_initialize_by(email: email)
                 end
      end
      user.add_auth(auth)
      user.apply_auth(auth)
    end

    def new_with_session(params, session)
      super.tap do |user|
        if (data = session["devise.omniauth_data"]).present?
          auth_token = data["credentials"]["token"] rescue nil
          binding.pry
          user.authentications.build(provider: data['provider'], uid: data['uid'], token: auth_token)
        end
      end
    end
  end

  def apply_auth(auth)
    if auth.provider.eql?('twitter') && auth.info.name.to_s[/([\S]+) ([\S]+)/i]
      self.first_name = $1 if self.first_name.blank?
      self.last_name  = $2 if self.last_name.blank?
    else
      self.first_name = auth.info.first_name if self.first_name.blank?
      self.last_name  = auth.info.last_name  if self.last_name.blank?
      # VK
      self.username  = auth.info.nickname.presence  if self.username.blank?
    end
    self.password   = Devise.friendly_token[0,20] if self.encrypted_password.blank?

    if auth.provider.eql?('vkontakte')
      self.address = auth.info.location if self.address.blank?
    end

    # elsif auth.provider.eql?('odnoklassniki')
    #   self.city = auth.extra.raw_info.location.city if self.city.blank?
    # else
    #   self.city =  auth.location if self.city.blank?
    # end

    # Avatar
    if self.avatar.blank?
      if (image_uri = auth.info.image).present?
        image_uri = auth.info.image.gsub('http://','https://') + '?type=large' if auth.provider.eql?('facebook')
        self.remote_avatar_url = image_uri
      end
    end

    self.email = "#{auth.uid}.#{auth.provider}@example.com" if self.email.blank?
    if (email = auth.recursive_find_by_key("email")).present? && self.has_dummy_email?
      self.email = email
    end

    self.phone = DUMMY_PHONE+rand(10**6).to_s if self.phone.blank?

    new = self.new_record?
    self.skip_confirmation! if new
    if self.save
      self.send_reset_password_instructions if new
    else
      logger.error("ERROR: new user #{self.email} has not been created: #{self.errors.full_messages.to_sentence}")
    end

    self.confirm if !self.confirmed? || self.has_dummy_email?
    self
  end

  def add_auth(auth)
    authentication = self.authentications.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    authentication.token = auth.credentials.token rescue nil
    authentication.expires_at = Time.at(auth.credentials.expires_at) rescue nil
    # VK
    authentication.url = auth.info.urls.values.first rescue nil
    # facebook doesn't return URL for some reason
    authentication.url = "https://www.facebook.com/#{auth.uid}" if auth.provider.eql?('facebook')
    authentication.save if authentication.persisted?
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def has_dummy_email?
    self.email[/@example.com/].present?
  end

  def has_dummy_phone?
    self.phone.to_s[DUMMY_PHONE].present?
  end

  def not_dummy_phone?
    !has_dummy_phone?
  end
end
