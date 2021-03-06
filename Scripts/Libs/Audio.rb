module Audio
  def self.setup_midi; end
  def self.bgm_play(filename, volume = 50, pitch = 0, pos = 0); end
  def self.bgm_stop; end
  def self.bgm_fade(time); end
  def self.bgm_pos; end
  def self.bgs_play(filename, volume=50, pitch=0, pos = 0); end
  def self.bgs_stop; end
  def self.bgs_fade(time); end
  def self.bgs_pos; end
  def self.me_play(filename, volume=50, pitch=0); end
  def self.me_stop; end
  def self.me_fade(time); end
  def self.se_play(filename, volume=50, pitch=0); end
  def self.se_stop; end
end