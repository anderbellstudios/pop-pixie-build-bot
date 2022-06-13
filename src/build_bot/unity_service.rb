require 'open3'

class UnityService
  PlatformConfig = Struct.new(:command_line_option, :file_extension)

  def build_for_platforms(platforms_dirs, game_name:)
    platform_args = platforms_dirs.map do |platform, dir|
      platform_config = platform_config_for(platform)
      [platform_config.command_line_option, quote(File.join(dir, game_name + platform_config.file_extension))]
    end

    command = [
      quote(Environment.fetch(:UNITY_BINARY)),
      '-projectPath', quote(Environment.fetch(:UNITY_PROJECT)),
      '-batchmode',
      '-nographics',
      platform_args,
      '-quit',
      '2>&1',
    ].flatten.join(' ')

    Open3.pipeline(command, out: $stdout).then do |statuses|
      unless statuses.all?(&:success?)
        raise 'Failed to build Unity project'
      end
    end

    platforms_dirs.map do |platform, dir|
      Build.new(platform: platform, dir: dir)
    end
  end

  private

  def platform_config_for(platform)
    {
      windows: PlatformConfig.new('-buildWindows64Player', '.exe'),
      macos: PlatformConfig.new('-buildOSXUniversalPlayer', ''),
    }.fetch(platform)
  end

  def quote(string)
    "'#{string.gsub("'", "\\'")}'"
  end
end
