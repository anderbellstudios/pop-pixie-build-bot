require_relative 'test_helper'

class PackagerTest < TestCase
  BuildDouble = Struct.new(:platform, keyword_init: true)

  module WindowsPackagerDouble
    def self.package(build)
      { i_just_packaged: build }
    end
  end

  setup do
    @packager = Packager.new(platform_packagers: { windows: WindowsPackagerDouble })
  end

  test 'delegates #package to the platform packager' do
    build = BuildDouble.new(platform: :windows)
    assert_equal WindowsPackagerDouble.package(build), @packager.package(build)
  end

  test 'raises an error if the platform packager does not exist' do
    build = BuildDouble.new(platform: :linux)
    assert_raises(RuntimeError) { @packager.package(build) }
  end
end
