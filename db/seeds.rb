Category.destroy_all

6.times do 
  Category.create!(
    title: Faker::Book.genre,
    color: Faker::Color.hex_color
  )
end

30.times do
  Course.create!(
    title: Faker::Beer.style,
    category_id: Category.pluck(:id).sample,
    summary: Faker::Lorem.paragraphs(1).first
  )
end

300.times do
  Lesson.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraphs(5).join(' '),
    course_id: Course.pluck(:id).sample,
    position: rand(1..100)
  )
end