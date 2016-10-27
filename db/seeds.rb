#
# 50.times do
#   User.create(first_name: Faker::Name.first_name,
#               last_name: Faker::Name.last_name,
#               email: Faker::Internet.email,
#               password_digest: User.new(password: password).password_digest)
# end
# User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
# Product.connection.execute('ALTER SEQUENCE products_id_seq RESTART WITH 1')
# Review.connection.execute('ALTER SEQUENCE reviews_id_seq RESTART WITH 1')
# Category.connection.execute('ALTER SEQUENCE categories_id_seq RESTART WITH 1')

password = 'password'

50.times do
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.email = Faker::Internet.email
  user.password_digest = User.new(:password => password).password_digest
  user.save
end
10.times do
  Category.create(name: Faker::Company.name)
end

1000.times do
  price = 10 + rand(1000)
   product = Product.create({title: Faker::Commerce.product_name,
                  description: Faker::Company.catch_phrase,
                  category: Category.order("RANDOM()").first,
                  price: price,
                  sale_price: rand(price),
                  hit_count: 1 + rand(10),
                  user: User.order("RANDOM()").first})
  random = rand(5)
  random.times do
    Review.create(body: Faker::Hipster.paragraph,
                  star_count: 1 + rand(4),
                  product: product,
                  user: User.order("RANDOM()").first)
  end
end
puts "Made the products, categories, and reviews"
