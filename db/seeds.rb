TEST_USER = 'test@test.com'
TEST_USER_2 = 'test2@test.com'
DEFAULT_PASSWORD = 'password'

test_user = User.find_or_initialize_by(email: TEST_USER)
test_user.password = DEFAULT_PASSWORD
test_user.save
test_user.friends = []

test_user_2 = User.find_or_initialize_by(email: TEST_USER_2)
test_user_2.password = DEFAULT_PASSWORD
test_user_2.save
test_user_2.friends = []

users = (0..100).map do
  email = Faker::Internet.email

  user = User.find_or_initialize_by(email: email)
  user.password = DEFAULT_PASSWORD
  user.save

  user.friends = []

  user
end

users << test_user
users << test_user_2

test_user.friends << test_user_2
test_user_2.friends << test_user

users.each do |user|
  friends = users.sample(rand(3..10))
  user.friends = friends
  friends.each do |friend|
    friend.friends << user
  end

  friends.each do |friend|
    (rand(1..50)).times do
      user_id, friend_id = [user.id, friend.id].shuffle
      Message.create(user_id: user_id, receiver_id: friend_id, content: Faker::Lorem.paragraph(rand(1..5)))
    end
  end
end

covers = Dir["#{Rails.root.join("public", "covers")}/*.*"]
avatars = Dir["#{Rails.root.join("public", "avatars")}/*.*"]

users.each do |user|
  avatar = avatars.sample
  user.avatar.attach(io: File.open(avatar), filename: avatar, content_type: "image/jpeg")

  cover = covers.sample
  user.cover.attach(io: File.open(cover), filename: cover, content_type: "image/jpeg")

  rand(1..15).times do
    post = user.posts.new
    post.content = Faker::Lorem.paragraph(rand(0..5))
    post.save

    if rand(0..2) == 1
      post_image = covers.sample
      post.image.attach(io: File.open(post_image), filename: post_image, content_type: "image/jpeg")
    end

    post.update(created_at: Time.now - rand(1..365).days)
  end
end

Friendship.all.each do |f|
  f.update(created_at: Time.now - rand(1..365).days)
end
