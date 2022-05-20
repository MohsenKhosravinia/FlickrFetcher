# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'FlickrFetcher' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FlickrFetcher
  pod 'Alamofire', '~> 5.4.0'
  pod 'AlamofireNetworkActivityLogger', '~> 3.4'
  pod 'Kingfisher', '~> 7.0'
  pod 'SwiftLint'

  target 'FlickrFetcherTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# ----------------------------------------------------------------
# brute force deployment target on pods
# ----------------------------------------------------------------

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
