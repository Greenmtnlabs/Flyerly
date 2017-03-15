platform :ios, '8.0'

    pod 'AFNetworking', '~> 2.5.4'
    pod 'uservoice-iphone-sdk', '~> 3.2.3'
    pod 'PayPal-iOS-SDK', '~> 2.14.0'

    #pod 'ShareKit', '~> 4.0.4'
    pod 'ShareKit', :podspec => "Podspecs/ShareKit.podspec"
    pod 'GoogleAPIClient'

    pod 'Facebook-iOS-SDK', '~> 3.23.2'

    # Pre-release versions:
    # Recommended to keep GPUImage up-to-date
    pod 'GPUImage'
    pod 'NBUKit', '~> 2.4.1'
    pod 'NBUImagePicker', '~> 1.5.3'

    pod 'Parse', '~> 1.7.3'
    pod 'ParseFacebookUtils', '~> 1.7.4'

    # Open SSL
    pod 'OpenSSL', '~> 1.0'

    pod 'FBSDKCoreKit', '~> 4.6'
    pod 'FBSDKShareKit', '~> 4.6'
    pod 'FBSDKMessengerShareKit', '~> 1.3.2'
    pod 'CrittercismSDK'
    pod 'GTMHTTPFetcher'
    pod 'GTMSessionFetcher'
    pod 'GTMOAuth2'

    post_install do |installer_representation|
        installer_representation.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'YES'
            end
        end
    end

    target 'Flyr' do
    end

    target 'FlyerlyBiz' do
    end
