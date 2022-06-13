require_relative 'test_helper'

class BuildTest < TestCase
  setup do
    @build = Build.new(platform: :windows, dir: Dir.mktmpdir)
  end

  test 'clean_up removes the directory and its contents' do
    system('touch', File.join(@build.dir, 'my_file'))
    assert_includes Dir.entries(@build.dir), 'my_file'
    @build.clean_up
    refute Dir.exist?(@build.dir), 'directory still exists'
  end

  test 'mv moves the directory to a new location and updates the dir attribute' do
    destination_container = Dir.mktmpdir
    destination_path = File.join(destination_container, 'destination')

    old_path = @build.dir
    @build.mv(destination_path)

    refute Dir.exist?(old_path), 'old directory still exists'
    assert Dir.exist?(destination_path), 'new directory does not exist'

    assert_equal destination_path, @build.dir

    @build.clean_up
  end
end
