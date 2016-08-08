Pod::Spec.new do |s|
s.name         = 'PhotoBrowser'
s.version      = '1.0'
s.summary      = 'An easy way to browse photo(image) for iOS.'
s.homepage     = 'https://github.com/ellmcz/PhotoBrowser'
s.license      = 'MIT'
s.authors      = {'Ellmcz' => 'wqbs007@163.com'}
s.platform     = :ios, '8.0'
s.dependency "SDWebImage"
s.dependency "MBProgressHUD"
s.source       = {:git => 'https://github.com/ellmcz/PhotoBrowser.git', :tag => '1.0'}
s.source_files = 'PhotoBrowser/*.{h,m}'
s.resource     = 'PhotoBrowser/PhotoBrowser.bundle'
s.requires_arc = true
s.framework = 'UIKit'
end

