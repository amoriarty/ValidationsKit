#
# Be sure to run `pod lib lint ValidationKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ValidationsKit'
s.version          = '1.2.0'
s.summary          = 'Model validation for iOS, inspired by Vapor.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
ValidationsKit is a package inspired by Vapor Validation, in order to bring model validation with simple and clean syntax on iOS. If you do server side swift with Vapor, you should already be very familiar with this package.
DESC

s.homepage         = 'https://github.com/amoriarty/ValidationsKit'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
s.author           = { 'amoriarty' => 'alexandrelegent@gmail.com' }
s.source           = { :git => 'https://github.com/amoriarty/ValidationsKit.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/alex_legent'

s.swift_version = '5.1'
s.ios.deployment_target = '11.0'
s.source_files = 'Sources/ValidationsKit/**/*'

# s.resource_bundles = {
#   'ValidationsKit' => ['ValidationKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
