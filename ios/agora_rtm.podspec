#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agora_rtm.podspec` to validate before publishing.
#
require "yaml"
require "ostruct"
project = OpenStruct.new YAML.load_file("../pubspec.yaml")
Pod::Spec.new do |s|
  s.name             = project.name
  s.version          = project.version
  s.summary          = 'A new flutter plugin project.'
  s.description      = project.description
  s.homepage         = project.homepage
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Agora' => 'developer@agora.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AgoraRtm_iOS', '1.5.1'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
