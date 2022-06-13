require 'tmpdir'

class Builder
  def initialize(unity_service: UnityService.new)
    @unity_service = unity_service
  end

  def build_for_platforms(platforms)
    platforms_dirs = platforms.map do |platform|
      [platform, Dir.new(Dir.mktmpdir)]
    end.to_h

    @unity_service.build_for_platforms(platforms_dirs)
  end
end
