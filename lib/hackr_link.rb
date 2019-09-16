module HackrLink
  def self.init
    load_config
  end

  def self.load_config
    load 'lib/hackr_link/config.rb'
    HackrLink::Config.load_yaml 'config/application.yml'
  end
end
