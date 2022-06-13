require_relative 'test_helper'

class BuilderTest < TestCase
  BuildDouble = Struct.new(:platform, :dir)

  class UnityServiceDouble
    def build_for_platforms(platform_dirs)
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
    build([:mac, :linux])
    assert_equal [:mac, :linux], @builds.map(&:platform)
  end

  test 'creates a temporary directory for each platform' do
    build

    @builds.map(&:dir).each do |dir|
      assert_equal true, File.directory?(dir)
    end
  end

  private

  def build(platforms = [:windows, :mac, :linux])
    @builds = @builder.build_for_platforms(platforms)
  end
end
