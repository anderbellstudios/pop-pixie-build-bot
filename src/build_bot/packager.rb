require './packagers/pop-pixie-windows-installer/binding'
require './packagers/pop-pixie-macos-dmg/binding'

class Packager
  def initialize(platform_packagers: { windows: WindowsPackager, macos: MacOSPackager })
    @platform_packagers = platform_packagers
  end

  def package(build)
    @platform_packagers.fetch(build.platform) { raise "No packager for #{build.platform}" }.package(build)
  end
end
