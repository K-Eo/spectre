class TerminalsHelperTest < ActionView::TestCase

  test "tab_item should generate link for tab" do
    link = %{<a class="nav-link" href="/">Test</a>}
    expected = %{<li class="nav-item">#{link}</li>}
    assert_dom_equal expected, tab_item('Test', '/')
  end

  test "tab_item should generate active link for tab" do
    link = %{<a class="nav-link active" href="test">Test</a>}
    expected = %{<li class="nav-item">#{link}</li>}
    assert_dom_equal expected, tab_item('Test', 'test')
  end

end
