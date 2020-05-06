#
# Be sure to run `pod lib lint YHRunLoopTask.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YHRunLoopTask'
  s.version          = '0.1.0'
  s.summary          = 'Control task in block style in runloop.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.

1、RunLoop for control multiple tasks.

2、Do task in NSDefalutRunLoopMode before waiting status,avoid blocking UI display in UITrackingRunLoopMode .

3、Can manual wake runloop for triggering task.

DESC

  s.homepage         = 'https://github.com/FyhSky/YHRunLoopTask'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'FyhSky' => 'fengyinghaotjut@126.com' }
  s.source           = { :git => 'https://github.com/FyhSky/YHRunLoopTask.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YHRunLoopTask/Classes/*.{h,m}'
  
  # s.resource_bundles = {
  #   'YHRunLoopTask' => ['YHRunLoopTask/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
