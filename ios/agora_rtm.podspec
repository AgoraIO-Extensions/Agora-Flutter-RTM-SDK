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
  s.summary          = 'A new Flutter plugin project.'
  s.description      = project.description
  s.homepage         = project.homepage
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Agora' => 'developer@agora.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.libraries = 'stdc++'

  plugin_dev_path = File.join(File.dirname(File.realpath(__FILE__)), '..', '.plugin_dev')
  if File.exist?(plugin_dev_path)
    puts '[plugin_dev] Found .plugin_dev file, use vendored_frameworks instead.'
    s.vendored_frameworks = 'libs/*.xcframework'
  else
  s.dependency 'AgoraIrisRTM_iOS', '2.2.1-build.1'
  s.dependency 'AgoraRtm', '2.2.1'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
