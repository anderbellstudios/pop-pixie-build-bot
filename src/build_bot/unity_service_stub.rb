class UnityServiceStub
  def build_for_platforms(platform_dirs, game_name:)
    platform_dirs.map do |platform, dir|
      File.write(File.join(dir, 'test.txt'), platform.to_s)
      Build.new(platform: platform, dir: dir)
    end
  end
end
