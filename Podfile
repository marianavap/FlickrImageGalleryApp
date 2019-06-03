platform :ios, '12.1'
use_frameworks!
inhibit_all_warnings!

def commomPods
  pod 'Kingfisher', "~>5.1"
  pod 'SwiftMessages', "~>6.0"
  pod 'Reachability', "~>3.2"
  pod 'AFNetworking', '~> 3.0'
  pod 'SwiftyJSON'
end

target 'FlickrImageGalleryApp' do
  
  commomPods
  
  target 'FlickrImageGalleryAppTests' do
    inherit! :complete
  end
  
  target 'FlickrImageGalleryAppUITests' do
    inherit! :complete
  end
end
