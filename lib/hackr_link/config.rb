require 'yaml'
require 'active_support/core_ext/string'

module HackrLink
  module Config
    @@settings = {}

    def self.load_yaml(file)
      @@settings.merge! ::YAML::load_file file
    end

    def self.[](key)
      @@settings[key.to_s]
    end

    def self.settings
      @@settings
    end
  end
end
