require 'yaml'

module Environment
  @@env = ENV

  def self.load_environment(path)
    @@env.merge!(YAML.load_file(path)) if File.exist?(path)
  end

  def self.fetch(key)
    @@env.fetch(key.to_s) { raise "Environment variable #{key} not set" }
  end
end
