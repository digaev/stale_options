require 'test_helper'

class StaleOptionsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::StaleOptions::VERSION
  end

  def test_create_returns_hash
    h = StaleOptions.create(nil)

    assert h.is_a?(Hash)
    assert_equal h.keys.length, 2

    assert h.key?(:etag)
    assert h.key?(:last_modified)
  end

  def test_create_with_nil
    h = StaleOptions.create(nil)

    assert_nil h[:etag]
    assert_nil h[:last_modified]
  end

  def test_create_with_options
    mock = Minitest::Mock.new
    mock.expect(:itself, 0)
    mock.expect(:created_at, Time.now)

    StaleOptions.create(mock, cache_by: :itself, last_modified: :created_at)

    assert_mock mock
  end

  def test_create_with_last_modified_nil
    h = StaleOptions.create(0, cache_by: :itself, last_modified: nil)

    assert_nil h[:last_modified]
  end

  def test_create_with_last_modified_time
    t = Time.now
    h = StaleOptions.create(0, cache_by: :itself, last_modified: t)

    assert_equal h[:last_modified], t
  end

  def test_create_with_empty_array
    h = StaleOptions.create([])

    assert h[:etag].is_a?(String)
    assert_nil h[:last_modified]
  end

  def test_create_with_non_empty_array
    array = Array.new(3) { |i| TestModel.new(updated_at: Time.now - i.minutes) }
    h = StaleOptions.create(array)

    assert h[:etag].is_a?(String)
    assert_equal h[:last_modified], array.first.updated_at
  end

  def test_create_with_non_empty_simple_array
    h = StaleOptions.create([1, 2, 3], cache_by: :itself, last_modified: nil)

    assert h[:etag].is_a?(String)
    assert_nil h[:last_modified]
  end

  def test_create_with_empty_relation
    h = StaleOptions.create(TestModel.where(id: nil))

    assert h[:etag].is_a?(String)
    assert_nil h[:last_modified]
  end

  def test_create_with_non_empty_relation
    h = StaleOptions.create(TestModel.all)
    most_recent = TestModel.most_recent.first

    assert h[:etag].is_a?(String)
    assert_equal h[:last_modified], most_recent.updated_at
  end

  def test_time?
    assert StaleOptions.time?(DateTime.now)
    assert StaleOptions.time?(Time.current)
    assert StaleOptions.time?(Time.now)

    assert_equal StaleOptions.time?(nil), false
  end
end
