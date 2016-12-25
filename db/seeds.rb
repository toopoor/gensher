if first_admin = User.create(email: 'admin@gg.com', phone: '+380935000000', password: 'password', password_confirmation: 'password')
  first_admin.confirm!
  first_admin.admin!
  puts "First admin added\nEmail: 'admin@gg.com'\nPassword: 'password'"
end

if first_user = User.create(email: 'user@gg.com', phone: '+380935000111', password: 'password', password_confirmation: 'password')
  first_user.confirm!
  puts "First user added\nEmail: 'user@gg.com'\nPassword: 'password'"
end