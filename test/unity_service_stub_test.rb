require_relative 'test_helper'

class UnityServiceStubTest < TestCase
  setup do
    @platform_dirs = {
      windows: Dir.mktmpdir,
      macos: Dir.mktmpdir,
    }
  end

  teardown do
    @platform_dirs.each_value { |dir| FileUtils.rm_rf(dir) }
  end

  test 'creates a test file in each of the given directories' do
    builds = UnityServiceStub.new.build_for_platforms(@platform_dirs, game_name: 'My Game')

    builds.each do |build|
      assert_equal build.platform.to_s, File.read(File.join(build.dir, 'test.txt'))
    end
  end
end
