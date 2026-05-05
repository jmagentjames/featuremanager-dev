if Rails.env.development?
  admin = User.find_or_initialize_by(email: "jonas.montonen@gmail.com")
  admin.name = "Jonas Montonen"
  admin.password = "password123"
  admin.admin = true
  if admin.save!
    puts "Admin user created: jonas.montonen@gmail.com / password123"
  else
    puts "Admin user already exists"
  end
end
