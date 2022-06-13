$LOAD_PATH.unshift File.expand_path("../src", __dir__)
require 'build_bot'
require 'minitest/pride'
require 'minitest/autorun'

class TestCase < Minitest::Test
  class << self
    def test(name, &block)
      define_method("test_#{name}", &block)
    end

    def setup(&block)
      define_method(:setup, &block)
    end

    def teardown(&block)
      define_method(:teardown, &block)
    end
  end
end
