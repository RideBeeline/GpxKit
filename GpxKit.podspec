Pod::Spec.new do |s|
  s.name         = "GpxKit"
  s.version      = "3.0.0"
  s.license      = "MIT"
  s.summary      = "Swift GPX parser and writer"
  s.homepage     = "https://github.com/beeline/GpxKit"
  s.author       = { "marcbaldwin" => "marc.baldwin88@gmail.com" }
  s.source       = { :git => "https://github.com/beeline/GpxKit.git", :tag => s.version }
  s.source_files = "GpxKit/*.swift"
  s.ios.deployment_target = '15.0'
  s.swift_version = '5'
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.framework  = "Foundation"
    ss.dependency "SWXMLHash", '~> 6'
    ss.dependency "RxSwift", '~> 6.5'
  end

end
