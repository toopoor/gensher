class ContactMailer < ActionMailer::Base
  # TODO extract  to settings  gem 'figaro'
  default from: 'no-reply@gensherman.com', to: 'gensherman.com@gmail.com'

  def sponsor_news(message, user)
    @message = message
    mail(subject: "Новость: #{@message.subject}", to: user.email)
  end

  def feedback(message)
    @message = message
    mail(subject: "Обратная связь: #{@message.subject}")
  end

  def notify(contact)
    @contact = contact
    mail(subject: "Message from #{contact.name}(#{contact.email})")
  end
end
