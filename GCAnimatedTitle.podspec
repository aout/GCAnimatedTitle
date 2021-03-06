Pod::Spec.new do |s|
  s.name         = "GCAnimatedTitle"
  s.version      = "0.6"
  s.summary      = "A Twitter-like navigation bar title (using a UIScrollView)."

  s.homepage     = "https://github.com/aout/GCAnimatedTitle"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "Guillaume CASTELLANA" => "guillaume.castellana@gmail.com" }
  s.social_media_url   = "http://twitter.com/aooout"

  s.platform     = :ios, '5.0'

  s.source       = { :git => "https://github.com/aout/GCAnimatedTitle.git", :tag => "0.6" }

  s.source_files  = "AnimatedTitle/Classes"
  s.public_header_files = "AnimatedTitle/Classes/*.h"

  s.requires_arc = true
end
