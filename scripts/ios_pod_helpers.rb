require 'fileutils'

# RTC 4.x can bring an older AgoraInfra AOSL. RTM 2.3.1 requires the newer
# bundled copy; deleting it can also leave arm64 simulators without a framework.
def deduplicate_rtm_aosl(installer)
  rtm_aosl = File.join(installer.sandbox.root, 'ShengwangRtm_iOS', 'aosl.xcframework')
  return unless File.directory?(rtm_aosl)

  rtc_aosl = File.join(installer.sandbox.root, 'AgoraInfra_iOS', 'aosl.xcframework')
  if File.directory?(rtc_aosl)
    puts 'Using the AOSL bundled with ShengwangRtm_iOS instead of the RTC duplicate'
    FileUtils.rm_rf(rtc_aosl)
  end
end
