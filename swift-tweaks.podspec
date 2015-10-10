Pod::Spec.new do |s|
  s.name = 'SwiftTweaks'
  s.version = '2.1.1'
  s.license = 'MIT'
  s.summary = 'Set of helper classes and functions for every Xcode project.'
  s.homepage = 'https://github.com/VojtaStavik/iOS-SwiftTweaks'
  s.social_media_url = 'http://twitter.com/VojtaStavik'
  s.authors = { "Vojta Stavik" => "stavik@outlook.com" }
  s.source = { :git => 'https://github.com/VojtaStavik/iOS-SwiftTweaks', :tag => s.version, :branch => 'Swift2' }
  s.ios.deployment_target = '7.0'
  s.watchos.deployment_target = '2.0'
  s.source_files   = '*.swift'
  s.frameworks = 'UIKit'
  s.requires_arc = true
end
