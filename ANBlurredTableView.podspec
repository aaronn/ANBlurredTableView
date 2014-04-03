Pod::Spec.new do |s|
  s.name         = "ANBlurredTableView"
  s.version      = "0.0.1"
  s.summary      = "ANBlurredTableView is a simple UITableView subclass for blurring and tinting a background image on scroll."
  s.homepage     = "https://github.com/JSubida/ANBlurredTableView"
  s.license      = { :type => 'Unknown', :file => './LICENSE' }
  s.author       = { "Aaron Ng" => "hi@aaron.ng" }
  s.source       = { :git => "https://github.com/aaronn/ANBlurredTableView.git", :commit => "70f30157014f0435258323f4bd91f9bcb7da899c" }
  s.source_files = "ANBlurredTableView/*"
  s.platform		 = :ios
	s.framework  	 = "Accelerate", "QuartzCore", "Foundation", "CoreGraphics"
end
