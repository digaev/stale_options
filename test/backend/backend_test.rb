require 'test_helper'

class BackendTest < Minitest::Test
  def test_if_stale_true
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, true, [options])

      block_called = false

      class << mock
        include StaleOptions::Backend
      end

      mock.send(:if_stale?, 0) do |record|
        block_called = true
        assert_equal record, 0
      end

      assert_mock mock
      assert block_called
    end
  end

  def test_if_stale_true_without_block
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, true, [options])

      class << mock
        include StaleOptions::Backend
      end

      assert mock.send(:if_stale?, 0)
      assert_mock mock
    end
  end

  def test_if_stale_false
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, false, [options])

      class << mock
        include StaleOptions::Backend
      end

      mock.send(:if_stale?, 0) do |_|
        raise 'Should not be called!'
      end

      assert_mock mock
    end
  end

  def test_unless_stale_true
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, false, [options])

      block_called = false

      class << mock
        include StaleOptions::Backend
      end

      mock.send(:unless_stale?, 0) do |record|
        block_called = true
        assert_equal record, 0
      end

      assert_mock mock
      assert block_called
    end
  end

  def test_unless_stale_true_without_block
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, false, [options])

      class << mock
        include StaleOptions::Backend
      end

      assert mock.send(:unless_stale?, 0)
      assert_mock mock
    end
  end

  def test_unless_stale_false
    options = { etag: '123' }.freeze

    StaleOptions.stub :create, options do
      mock = Minitest::Mock.new
      mock.expect(:stale?, true, [options])

      class << mock
        include StaleOptions::Backend
      end

      mock.send(:unless_stale?, 0) do |_|
        raise 'Should not be called!'
      end

      assert_mock mock
    end
  end
end
