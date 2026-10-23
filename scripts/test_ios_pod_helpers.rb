require 'tmpdir'
require 'ostruct'
require_relative 'ios_pod_helpers'

[true, false].each do |rtm_present|
  Dir.mktmpdir('rtm-aosldedup-') do |root|
    rtm = File.join(root, 'ShengwangRtm_iOS', 'aosl.xcframework')
    rtc = File.join(root, 'AgoraInfra_iOS', 'aosl.xcframework')
    other = File.join(root, 'OtherPod', 'aosl.xcframework')
    FileUtils.mkdir_p([rtc, other])
    FileUtils.mkdir_p(rtm) if rtm_present
    installer = OpenStruct.new(sandbox: OpenStruct.new(root: root))

    # A repeated pod install must not delete the selected RTM provider.
    2.times { deduplicate_rtm_aosl(installer) }
    raise 'RTM provider changed' unless File.directory?(rtm) == rtm_present
    raise 'Wrong RTC duplicate handling' unless File.directory?(rtc) == !rtm_present
    raise 'Unrelated framework removed' unless File.directory?(other)
  end
end
puts 'AOSL provider selection tests passed'
