class CodeNameGenerator
  ADJECTIVES = %w[
    Shadow Silent Phantom Ghost Rogue Swift Stealth Dark Iron Steel
    Crimson Azure Emerald Golden Silver Midnight Thunder Lightning Storm
    Frost Viper Cobra Scorpion Falcon Eagle Hawk Raven Wolf Tiger
  ].freeze

  NOUNS = %w[
    Falcon Eagle Viper Wolf Raven Hawk Panther Tiger Cobra Dragon
    Phoenix Sphinx Griffin Kraken Hydra Cerberus Pegasus Chimera
    Sentinel Guardian Warden Keeper Protector Hunter Stalker Tracker
    Operative Agent Assassin Ranger Scout Sniper Striker Reaper
  ].freeze

  def self.generate
    "#{ADJECTIVES.sample} #{NOUNS.sample}"
  end
end
