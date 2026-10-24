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

TestPodTarget = Struct.new(:name, :dependencies, :build_configurations) do
  def add_dependency(target)
    dependencies << OpenStruct.new(target: target)
  end
end

Dir.mktmpdir('rtm-aosllink-') do |root|
  FileUtils.mkdir_p(File.join(root, 'ShengwangRtm_iOS', 'aosl.xcframework'))
  provider = TestPodTarget.new('ShengwangRtm_iOS', [], [])
  config = OpenStruct.new(build_settings: { 'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', 'custom'] })
  consumer = TestPodTarget.new('agora_rtc_engine', [], [config])
  installer = OpenStruct.new(sandbox: OpenStruct.new(root: root),
    pods_project: OpenStruct.new(targets: [provider, consumer]))
  2.times { configure_rtm_aosl_consumers(installer) }
  raise 'Selected provider copy phase is not a dependency' unless consumer.dependencies.map(&:target) == [provider]
  expected = ['$(inherited)', 'custom', '"$(PODS_XCFRAMEWORKS_BUILD_DIR)/ShengwangRtm_iOS"']
  raise 'RTC does not resolve the selected AOSL provider' unless config.build_settings['FRAMEWORK_SEARCH_PATHS'] == expected
end
puts 'AOSL provider selection tests passed'
