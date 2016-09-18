#
# Be sure to run `pod lib lint MMUploadImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MMUploadImage'
  s.version          = '2.0.5'
  s.summary          = 'MMUploadImage'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Its a Extension helper for UIImageView to Upload a image when post to server'

  s.homepage         = 'https://github.com/MillmanY/UploadImage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Millman' => 'millmanyang@gmail.com' }
  s.source           = { :git => 'https://github.com/MillmanY/UploadImage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MMUploadImage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MMUploadImage' => ['MMUploadImage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.requires_arc = true

  # s.dependency 'AFNetworking', '~> 2.3'
end
