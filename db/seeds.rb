# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.destroy_all

6.times do 
  Category.create!(
    title: Faker::Book.genre,
    color: Faker::Color.hex_color
  )
end

30.times do
  Stack.create!(
    title: Faker::Beer.style,
    category_id: Category.pluck(:id).sample,
    summary: Faker::Lorem.paragraphs(1).first
  )
end

300.times do
  Lesson.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraphs(5).join(' '),
    stack_id: Stack.pluck(:id).sample,
    position: rand(1..100)
  )
end