require_relative 'test_helper'

class BuilderTest < TestCase
  BuildDouble = Struct.new(:platform, :dir)

  class UnityServiceDouble
    def build_for_platforms(platform_dirs, game_name:)
      platform_dirs.map { |platform, dir| BuildDouble.new(platform, dir) }
    end
  end

  setup do
    @builder = Builder.new(unity_service: UnityServiceDouble.new)
  end

  teardown do
    @builds&.each { |build| Dir.unlink(build.dir) }
  end

  test 'builds reflect given platforms' do
    build([:macos])
    assert_equal [:macos], @builds.map(&:platform)
  end

  test 'creates a temporary directory for each platform' do
    build

    @builds.map(&:dir).each do |dir|
      assert_equal true, File.directory?(dir)
    end
  end

  private

  def build(platforms = [:windows, :macos])
    @builds = @builder.build_for_platforms(platforms, game_name: 'My Game')
  end
end
