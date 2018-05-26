require 'rails_helper'
require_relative '../helpers/flow_helper'

RSpec.feature 'LessonFlows', type: :feature do
  include FlowHelper

  let(:admin) { create(:admin) }
  let(:lesson) { create(:lesson) }

  before do
    sign_in_user(admin, '')
  end

  scenario 'Admin adds a lesson' do
    visit new_lesson_path(lesson.course)

    fill_in 'Title', with: 'New Lesson Title'
    fill_in 'Body', with: 'Some text' * 20
    click_on 'Save'

    expect(page).to have_text('Lesson was successfully created.')
  end

  scenario 'Admin edits a lesson' do
    visit edit_lesson_path(lesson)

    expect(find_field('Title').value).to eq(lesson.title)
    expect(find_field('Body').value).to eq(lesson.body)

    fill_in 'Title', with: 'Something Different'
    fill_in 'Body', with: 'Some other text' * 40
    click_on 'Save'

    expect(current_path).to eq(lesson_path(lesson))
    expect(page).to have_text('Lesson was successfully updated.')
  end

  scenario 'Admin deletes a lesson' do
    visit edit_lesson_path(lesson)

    click_on 'Delete lesson'
    expect(Lesson.count).to eq(0)
    expect(page).to have_text('Lesson was successfully destroyed.')
  end
end
