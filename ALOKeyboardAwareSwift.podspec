Pod::Spec.new do |s|
  s.name         = "ALOKeyboardAwareSwift"
  s.version      = "1.2"
  s.summary      = "自适应键盘的 UIScrollView"
  s.homepage     = "https://github.com/andrew020/ALOKeyboardAwareSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrew.Leo" => "andrew2007@foxmail.com" }

  s.platform     = :ios, "8.0"
  s.swift_version = '4.0'
  s.source       = { :git => "https://github.com/andrew020/ALOKeyboardAwareSwift.git", :tag => "#{s.version}" }
  s.source_files = "*.{swift}"
  s.framework    = "UIKit","Foundation"
  s.requires_arc = true
end
