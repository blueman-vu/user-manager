# frozen_string_literal: true

User.create(role: 'admin', username: 'admin', email: 'admin@test.com', password: 'password')

for i in 0..10
  User.create(role: 'user', username: "user_#{i}", email: "user#{i}@test.com", password: 'password')
  for j in 0..12
    user = User.last
    Post.create(title: "Đây là title thứ #{i} của #{user.username}", is_published: true, user_id: user.id)
  end
end