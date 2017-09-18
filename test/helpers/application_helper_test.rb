require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  class FlashHelperTest < ActionView::TestCase

    def nuke(messages = {}, options = {})
      messages.each do |key, value|
        flash[key] = value
      end
      @output_buffer = flash_message(options)
    end

    test "returns message" do
      nuke({ notice: 'foobar' })

      assert_select '.flash-message.alert.alert-success.alert-dismissable.fade.show.my-0' do
        assert_select '.container-fluid' do |element|
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
      nuke({ notice: 'foobar' }, { col: 'col-10' })

      assert_select '.alert-success' do
        assert_select '.col-10'
      end
    end

    test "returns alert with container wrapper" do
      nuke({ notice: 'foobar' }, { container: 'foo-container' })

      assert_select '.alert-success' do
        assert_select '.foo-container'
      end
    end

  end

end
