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

# Removing the RTC duplicate also removes its generated framework search path.
# Link RTC against the selected RTM provider and wait for its copy phase.
def configure_rtm_aosl_consumers(installer)
  return unless File.directory?(File.join(installer.sandbox.root, 'ShengwangRtm_iOS', 'aosl.xcframework'))

  provider = installer.pods_project.targets.find { |target| target.name == 'ShengwangRtm_iOS' }
  consumer = installer.pods_project.targets.find { |target| target.name == 'agora_rtc_engine' }
  return unless provider && consumer

  consumer.add_dependency(provider) unless consumer.dependencies.any? { |dependency| dependency.target == provider }
  consumer.build_configurations.each do |config|
    paths = Array(config.build_settings['FRAMEWORK_SEARCH_PATHS'] || '$(inherited)')
    paths << '"$(PODS_XCFRAMEWORKS_BUILD_DIR)/ShengwangRtm_iOS"'
    config.build_settings['FRAMEWORK_SEARCH_PATHS'] = paths.uniq
  end
end
