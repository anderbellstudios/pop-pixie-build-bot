require 'tmpdir'

class Builder
  def initialize(unity_service:)
    @unity_service = unity_service
  end

  def build_for_platforms(platforms, game_name:)
    platforms_dirs = platforms.map do |platform|
      [platform, Dir.mktmpdir]
    end.to_h

    @unity_service.build_for_platforms(platforms_dirs, game_name:)
  end
end
