require_relative 'build_bot/environment'
require_relative 'build_bot/build'
require_relative 'build_bot/unity_service_stub'
require_relative 'build_bot/unity_service'
require_relative 'build_bot/builder'
require_relative 'build_bot/packager'
require_relative 'build_bot/zipper'
require_relative 'build_bot/uploader'
require_relative 'build_bot/notifier'

Environment.load_environment(File.expand_path('../env.yml', __dir__))

class BuildBot
  attr_reader :options, :builder, :packager, :zipper, :uploader, :notifier

  def initialize(options)
    @options = options
    @builder = Builder.new(unity_service: stub_builds? ? UnityServiceStub.new : UnityService.new)
    @packager = Packager.new
    @zipper = Zipper.new
    @uploader = Uploader.new
    @notifier = Notifier.new
  end

  def run
    builds = builder.build_for_platforms(target_platforms, game_name: game_name)

    builds.each { |build| system('open', build.dir) } if open_builds?

    platform_files = builds.map do |build|
      file = if package? then packager.package(build) else zipper.zip(build.dir, game_name: game_name) end
      [build.platform, file]
    end.to_h

    if upload?
      urls = platform_files.map { |platform, file| uploader.upload(file, platform: platform) }
      notifier.notify(urls, game_name: game_name)
    end

    builds.each(&:clean_up)
  end

  private

  def game_name
    options[:game_name]
  end

  def target_platforms
    options[:target_platforms]
  end

  def stub_builds?
    options[:stub_builds]
  end

  def open_builds?
    options[:open_builds]
  end

  def package?
    options[:package]
  end

  def upload?
    options[:upload]
  end
end
