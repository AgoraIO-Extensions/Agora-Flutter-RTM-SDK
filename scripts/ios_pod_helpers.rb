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

# Inspect the selected provider after CocoaPods has generated its copy phase.
# File-only tests cannot establish that a simulator framework is actually copied.
def report_rtm_aosl_copy(installer)
  root = installer.sandbox.root
  source = File.join(root, 'ShengwangRtm_iOS', 'aosl.xcframework')
  script = File.join(root, 'Target Support Files', 'ShengwangRtm_iOS', 'ShengwangRtm_iOS-xcframeworks.sh')
  puts "RTM AOSL provider present: #{File.directory?(source)}"
  if File.file?(script)
    File.foreach(script) do |line|
      puts "RTM copy phase: #{line.strip}" if line.start_with?('install_xcframework ')
    end
  end
end
