class TagService
  def self.generate
    timestamp = Time.now.to_f.to_s
    random_str = SecureRandom.hex(4)
    base = Digest::SHA256.hexdigest("#{timestamp}#{random_str}")

    base[0...8].gsub(/[^0-9A-Za-z]/, '0')
  end
end