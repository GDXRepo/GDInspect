Pod::Spec.new do |s|
  s.name             = "GDInspect"
  s.version          = "1.0.0"
  s.summary          = "Runtime class/object inspecting category built on top of the NSObject class."
  s.homepage         = "https://github.com/GDXRepo/GDInspect"
  s.license          = { :type => "Apache", :file => "LICENSE" }
  s.author           = { "Georgiy Malyukov" => "" }
  s.source           = { :git => "https://github.com/GDXRepo/GDInspect.git", :tag => s.version.to_s }
  s.social_media_url = 'http://deadlineru.livejournal.com'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
