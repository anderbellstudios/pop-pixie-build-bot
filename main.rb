require 'optparse'
require './src/build_bot'

options = {
  game_name: 'Pop Pixie',
  target_platforms: [],
  package: false,
  upload: false,
}

OptionParser.new do |opt|
  opt.on('--package') { options[:package] = true }
  opt.on('--upload') { options[:upload] = true }
  opt.on('--windows') { options[:target_platforms] << 'windows' }
  opt.on('--mac') { options[:target_platforms] << 'mac' }
  opt.on('--linux') { options[:target_platforms] << 'linux' }
end.parse!

options[:game_name] = ARGV[0] if ARGV[0]

BuildBot.new(options).run
