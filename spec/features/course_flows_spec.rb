require 'rails_helper'
require_relative '../helpers/flow_helper'

RSpec.feature 'CourseFlows', type: :feature do
  include FlowHelper
  
  let(:course) { create(:course) }
  let(:admin) { create(:admin) }

  before do
    sign_in_user(admin, 'nothing')
  end

  scenario 'Admin adds a course' do
    visit new_course_path(course.category)

    expect(find('#course_category_id', visible: false).value.to_i).to eq(course.category.id)
    fill_in 'Title', with: 'Example Title'
    fill_in 'Summary', with: 'Example body' * 20
    click_on 'Save'

    expect(page).to have_text('Course was successfully created.')
  end

  scenario 'Admin edits a course' do
    visit edit_course_path(course)

    expect(find('#course_category_id', visible: false).value.to_i).to eq(course.category.id)
    expect(find_field('Title').value).to eq(course.title)
    expect(find_field('Summary').value).to eq(course.summary)

    fill_in 'Title', with: 'Something Else'
    fill_in 'Summary', with: 'New Summary'
    click_on 'Save'

    expect(page).to have_text('Course was successfully updated.')
  end
end
