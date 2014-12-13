# encoding: utf-8

module Pluto

  MAJOR = 1
  MINOR = 2
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
    "pluto-models/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.generator   # convenience alias for banner (matches HTML generator meta tag)
    "Pluto #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end

end # module Pluto

