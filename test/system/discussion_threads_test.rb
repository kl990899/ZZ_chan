require "application_system_test_case"

class DiscussionThreadsTest < ApplicationSystemTestCase
  setup do
    @discussion_thread = discussion_threads(:one)
  end

  test "visiting the index" do
    visit discussion_threads_url
    assert_selector "h1", text: "Discussion threads"
  end

  test "should create discussion thread" do
    visit discussion_threads_url
    click_on "New discussion thread"

    fill_in "Title", with: @discussion_thread.title
    click_on "Create Discussion thread"

    assert_text "Discussion thread was successfully created"
    click_on "Back"
  end

  test "should update Discussion thread" do
    visit discussion_thread_url(@discussion_thread)
    click_on "Edit this discussion thread", match: :first

    fill_in "Title", with: @discussion_thread.title
    click_on "Update Discussion thread"

    assert_text "Discussion thread was successfully updated"
    click_on "Back"
  end

  test "should destroy Discussion thread" do
    visit discussion_thread_url(@discussion_thread)
    click_on "Destroy this discussion thread", match: :first

    assert_text "Discussion thread was successfully destroyed"
  end
end
