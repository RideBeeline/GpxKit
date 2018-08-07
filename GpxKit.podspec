Pod::Spec.new do |s|
  s.name         = "GpxKit"
  s.version      = "0.0.4"
  s.license      = "MIT"
  s.summary      = "Swift GPX parser and writer"
  s.homepage     = "https://github.com/beeline/GpxKit"
  s.author       = { "marcbaldwin" => "marc.baldwin88@gmail.com" }
  s.source       = { :git => "https://github.com/beeline/GpxKit.git", :tag => s.version }
  s.source_files = "GpxKit/*.swift"
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.framework  = "Foundation"
    ss.dependency "SWXMLHash", '~> 4'
    ss.dependency "RxSwift", '~> 4'
  end

end
