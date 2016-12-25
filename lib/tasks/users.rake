namespace :users do
  desc 'Add first user'
  task :add_first_user => :environment  do
    data = {email: 'admin@gensherman.com', password: 'asdlkj123', role: 'admin'}
    if User.find_by(email: data[:email]).blank?
      u = User.new(data)
      u.skip_confirmation!
      u.save(validate: false)
    end
  end

  desc 'Add client admins'
  task :add_admins => :environment do
    puts 'New admins:'

    emails = %w(gspodderzhka@gmail.com gspodderzhka1@gmail.com gspodderzhka2@gmail.com gspodderzhka3@gmail.com jvdoroshenko@gmail.com
    adm.sherman@yandex.ru adm.sherman@yandex.com adm.sherman@yandex.ua adm.sherman@yandex.kz ivoganisyan@gmail.com)
    emails.each do |email|
      u = User.new(email: email, password: Devise.friendly_token.first(8), role: 'admin')
      u.skip_confirmation!
      u.save(validate: false)
      puts "User: #{email} Password: #{u.password}"
    end
  end
end