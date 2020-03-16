require_relative 'src/lightbar'

Gem::Specification.new do |s|
  s.name         = 'lightbar'
  s.version      = Lightbar::VERSION
  s.summary      = 'Lightbar'
  s.description  = 'Lightbar PWM Tweening Controller'
  s.author       = 'Ryan Scott Lewis'
  s.email        = 'ryanscottlewis@gmail.com'
  s.license      = 'MIT'

  s.files        = Dir.glob(File.join('src', '**', '*'))
  s.files       += Dir.glob(File.join('bin', '**', '*'))
  s.files       += Dir.glob(File.join('share', '**', '*'))
  s.files       += ['Makefile', 'LICENSE', 'README.md']

  s.executables  = %w[lightbar]
end
