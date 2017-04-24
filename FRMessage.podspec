#
# Be sure to run `pod lib lint FRMessage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FRMessage"
  s.version          = "0.0.1"
  s.summary          = "Easy to use and customizable messages/notifications for iOS"
  s.description  = <<-DESC
                    This framework provides an easy to use class to show little notification views on the top of the screen.
The notification moves from the top of the screen underneath the navigation bar and stays there for a few seconds, depending on the length of the displayed text. To dismiss a notification before the time runs out, the user can swipe it to the top or just tap it.
There are 4 different types already set up for you: Success, Error, Warning, Message, Custom.
                   DESC
  s.homepage     = "https://github.com/zengfxios/FRMessage"

  s.license          = 'MIT'
  s.author           = { "zengfxios" => "zengfxios@gmail.com" }
  s.source           = { :git => "https://github.com/zengfxios/FRMessage.git", :tag => s.version.to_s }
  s.social_media_url = 'http://weibo.com/zfanxu'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'FRMessage/**/*.{h,m}'
  s.public_header_files = 'FRMessage/*.h'
  s.dependency 'Masonry'
end
