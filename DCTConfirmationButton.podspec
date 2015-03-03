Pod::Spec.new do |s|

  s.name         = "DCTConfirmationButton"
  s.version      = "1.0"
  s.summary      = "iOS 7 App Store-like button."

  s.description  = <<-DESC
# DCTConfirmationButton

A button subclass that acts like the app store button.
                   DESC

  s.homepage     = "https://github.com/danielctull/DCTConfirmationButton"
  s.license      = { :type => "BSD", :file => "LICENCE" }
  s.author             = "Daniel Tull"
  s.social_media_url   = "http://twitter.com/danielctull"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/danielctull/DCTConfirmationButton.git", :tag => "1.0" }
  s.source_files  = "DCTConfirmationButton/*.{h,m}"
  s.public_header_files = "DCTConfirmationButton/DCTConfirmationButton.h"
  s.resources = '**/DCTConfirmationButton.xcassets'
  s.requires_arc = true

end
