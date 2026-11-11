require 'tmpdir'
require 'fileutils'
require 'json'
require 'open3'

script = File.expand_path('../ci/run_update_deps.sh', __dir__)
Dir.mktmpdir('flutter-rtm-deps-') do |root|
  FileUtils.mkdir_p([File.join(root, 'ios'), File.join(root, 'android')])
  podspec = File.join(root, 'ios/agora_rtm.podspec')
  gradle = File.join(root, 'android/build.gradle')
  File.write(podspec, "keep_before\n# iris dependencies start\nold_iris\n# iris dependencies end\n# native dependencies start\nold_native\n# native dependencies end\nkeep_after\n")
  File.write(gradle, "keep_before\n    // iris dependencies start\nold_iris\n    // iris dependencies end\n    // native dependencies start\nold_native\n    // native dependencies end\nkeep_after\n")
  deps = [
    { platform: 'iOS', iris_cocoapods: ["pod 'AgoraIrisRTM_iOS', '2.3.1'"], cocoapods: ["pod 'Agora-Rtm/RtmKit', '2.3.1'", "pod 'Agora-Rtm/RtmBasic', '2.3.1'"] },
    { platform: 'Android', iris_maven: ["implementation 'io.agora.rtm:iris-rtm:2.3.1'"], maven: ["implementation 'io.agora.rtm:rtm-sdk:2.3.1'"] }
  ]
  2.times do
    _out, err, status = Open3.capture3('bash', script, JSON.generate(deps), chdir: root)
    raise err unless status.success?
    ios = File.read(podspec)
    android = File.read(gradle)
    raise 'Pod subspec lost or file truncated' unless ios.include?("s.dependency 'Agora-Rtm/RtmKit', '2.3.1'")
    raise 'Iris Pod lost' unless ios.include?("s.dependency 'AgoraIrisRTM_iOS', '2.3.1'")
    raise 'RTM AOSL subspec lost' unless ios.include?("s.dependency 'Agora-Rtm/RtmBasic', '2.3.1'")
    raise 'Android Iris lost' unless android.include?("api 'io.agora.rtm:iris-rtm:2.3.1'")
    raise 'Android dependency lost' unless android.include?("api 'io.agora.rtm:rtm-sdk:2.3.1'")
    [ios, android].each { |text| raise 'Unrelated content changed' unless text.start_with?("keep_before\n") && text.end_with?("keep_after\n") }
  end
  before = File.read(podspec)
  _out, err, status = Open3.capture3('bash', script, JSON.generate([{ platform: 'iOS', iris_cocoapods: ["pod 'AgoraIrisRTM_iOS', '2.3.1'"] }]), chdir: root)
  raise err unless status.success?
  raise 'Partial update removed Native dependency' unless File.read(podspec) == before
end
puts 'Dependency subspec update tests passed'
