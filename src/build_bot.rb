require_relative 'build_bot/builder'
require_relative 'build_bot/build'
require_relative 'build_bot/packager'

class BuildBot
  attr_reader :options, :builder, :packager, :zipper, :uploader

  def initialize(options)
    @options = options
    @builder = Builder.new
    @packager = Packager.new
    @zipper = Zipper.new
    @uploader = Uploader.new
  end

  def run
    builds = builder.build_for_platforms(target_platforms)

    files =
      if package?
        builds.map { |build| packager.package(build) }
      else
        builds.map { |build| zipper.zip(build) }
      end

    builds.each(&:clean_up)

    if upload?
      files.each { |file| uploader.upload(file) }
    end

    files.each(&:unlink)
  end

  private

  def game_name
    options[:game_name]
  end

  def target_platforms
    options[:target_platforms]
  end

  def package?
    options[:package]
  end

  def upload?
    options[:upload]
  end
end
