require 'optparse'
require_relative 'src/build_bot'

options = {
  game_name: 'Pop Pixie',
  target_platforms: [],
  stub_builds: false,
  open_builds: false,
  package: false,
  upload: false,
  notify: false,
  key_prefix: '',
}

OptionParser.new do |opt|
  opt.on('--windows') { options[:target_platforms] << :windows }
  opt.on('--macos') { options[:target_platforms] << :macos }
  opt.on('--stub-builds') { options[:stub_builds] = true }
  opt.on('--open-builds') { options[:open_builds] = true }
  opt.on('--package') { options[:package] = true }
  opt.on('--upload') { options[:upload] = true }
  opt.on('--notify') { options[:notify] = true }
  opt.on('--key-prefix=KEY_PREFIX') { |key_prefix| options[:key_prefix] = key_prefix }
end.parse!

options[:game_name] = ARGV[0] if ARGV[0]

BuildBot.new(options).run
