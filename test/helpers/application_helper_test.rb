require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  class TabItemTest < ActionView::TestCase

    def tab(name = nil, options = nil)
      @output_buffer = tab_item(name, options)
    end

    test "throws if name is not set" do
      assert_raises do
        tab(nil, { url: '/foobar' })
      end
    end

    test "returns item" do
      tab('Foobar', { url: '/foobar' })

      assert_select 'li.nav-item' do
        assert_select 'a.nav-link[href="/foobar"]', 'Foobar'
      end
    end

    test "returns item without active if controller does not include name" do
      tab('Test', { url: '/' })

      assert_select 'li.nav-item' do
        assert_select 'a.nav-link[href="/"]', 'Test'
      end
    end

    test "returns item with active if controller includes name" do
      tab('Test', { url: '/test' })

      assert_select 'li.nav-item' do
        assert_select 'a.nav-link.active[href="/test"]', 'Test'
      end
    end

  end

  class FlashHelperTest < ActionView::TestCase

    def nuke(messages = {}, col = nil)
      messages.each do |key, value|
        flash[key] = value
      end
      @output_buffer = flash_message(col)
    end

    test "returns message" do
      nuke({ notice: 'foobar' })

      assert_select '.flash-message.alert.alert-success.alert-dismissable.fade.show.my-0' do
        assert_select '.container' do |element|
          assert_match /foobar/, element.to_s
        end
      end
    end

    test "returns empty if no messages" do
      assert_match @output_buffer.to_s, ''
    end

    test "returns multiple messages" do
      nuke({ notice: 'foobar', danger: 'foobaz' })

      assert_select '.alert-success' do |element|
        assert_match /foobar/, element.to_s
      end

      assert_select '.alert-danger' do |element|
        assert_match /foobaz/, element.to_s
      end
    end

    test "returns danger alert if message is alert" do
      nuke({ alert: 'foobar' })

      assert_select '.alert-danger'
    end

    test "returns success alert if message is notice" do
      nuke({ notice: 'foobar' })

      assert_select '.alert-success'
    end

    test "returns alert based on message type" do
      nuke({ foo: 'bar' })

      assert_select '.alert-foo' do |element|
        assert_match /bar/, element.to_s
      end
    end

    test "returns alert with col wrapper" do
      nuke({ notice: 'foobar' }, 'col-10')

      assert_select '.alert-success' do
        assert_select '.col-10'
      end
    end

  end

end
