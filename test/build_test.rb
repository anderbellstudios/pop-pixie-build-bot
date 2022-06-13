require_relative 'test_helper'

class BuildTest < TestCase
  setup do
    @build = Build.new(platform: :windows, dir: Dir.new(Dir.mktmpdir))
  end

  test 'clean_up removes the directory and its contents' do
    system('touch', File.join(@build.dir.path, 'my_file'))
    assert_includes Dir.entries(@build.dir.path), 'my_file'
    @build.clean_up
    refute Dir.exist?(@build.dir.path), 'directory still exists'
  end
end
