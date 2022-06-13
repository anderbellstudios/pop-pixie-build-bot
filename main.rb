require 'optparse'
require_relative 'src/build_bot'

options = {
  game_name: 'Pop Pixie',
  target_platforms: [],
  stub_builds: false,
  open_builds: false,
  package: false,
  upload: false,
}

OptionParser.new do |opt|
  opt.on('--windows') { options[:target_platforms] << :windows }
  opt.on('--macos') { options[:target_platforms] << :macos }
  opt.on('--stub-builds') { options[:stub_builds] = true }
  opt.on('--open-builds') { options[:open_builds] = true }
  opt.on('--package') { options[:package] = true }
  opt.on('--upload') { options[:upload] = true }
end.parse!

options[:game_name] = ARGV[0] if ARGV[0]

BuildBot.new(options).run
