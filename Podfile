#source 'https://github.com/google/gtm-http-fetcher.git'
source 'https://github.com/google/gtm-session-fetcher.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.3'

pod 'uservoice-iphone-sdk', '~> 3.2.3'
pod 'PayPal-iOS-SDK', '~> 2.14.0'

pod 'ShareKit'#, :podspec => "Podspecs/ShareKit.podspec"
pod 'GoogleAPIClient'

# Pre-release versions:
# Recommended to keep GPUImage up-to-date
pod 'GPUImage'
pod 'NBUKit', '~> 2.4.1'
pod 'NBUImagePicker', '~> 1.5.3'

# Open SSL
#pod 'OpenSSL'#, '~> 1.0'
pod 'OpenSSL-Universal'#, :git => 'https://github.com/krzyzanowskim/OpenSSL.git', :branch => :master
pod 'SAMKeychain', '~> 1.5'

pod 'GooglePlusUtilities'

pod 'SDWebImage', '~> 4.0'

pod 'FBSDKLoginKit', '~> 4.44.1'
pod 'FBSDKShareKit', '~> 5.0.2'

pod 'Parse'
pod 'Parse/FacebookUtils'
pod 'Parse/TwitterUtils'
pod 'Parse/UI'

pod 'AFNetworking', '~> 3.1'

pod 'CrittercismSDK'


pod 'BitlySDK'
#pod 'GTMHTTPFetcher'
#pod 'gtm-http-fetcher'
#pod 'gtm-session-fetcher'
pod 'GTMSessionFetcher'
pod 'GTMOAuth2'

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.3'
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end


target 'Flyr' do
end

target 'FlyerlyBiz' do
end





