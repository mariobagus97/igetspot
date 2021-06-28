# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'mnc-igetspot-ios' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for mnc-igetspot-ios
    #base
    pod 'SnapKit',                '4.2.0'
    pod 'Alamofire',              '4.8.0'
    pod 'R.swift',                '5.0.0'
    pod 'TPKeyboardAvoiding',     '1.3.2'
    pod 'Version'
    pod 'PushNotifications'
    
    # floating panel
    pod 'FloatingPanel'
    
    #image
    pod 'SDWebImage',             '4.4.4'
    pod 'Lightbox',               '2.3.0'
    pod 'Kingfisher'
    
    #date
    pod 'SwiftDate'
    pod 'FSCalendar'
    
    #json
    pod 'SwiftyJSON',             '4.2.0'
    
    #persistance
    pod 'RealmSwift',             '3.19.0'
    pod 'KeychainAccess',         '3.1.2'
    
    # device info
    pod 'SDVersion'
    
    # buttons
    pod 'DLRadioButton', '~> 1.4.12'
    pod 'RNLoadingButton-Swift'

    #pager
    pod 'FSPagerView',            '0.8.2'
    pod 'Parchment',              '1.7.0'
    
    #parallax
    pod 'MXParallaxHeader'
    
    #popup, notifications
    pod 'SwiftMessages', '~> 6.0.2'
    
    #Loading
    pod 'SVProgressHUD', :git => 'https://github.com/mnizar/SVProgressHUD.git', :branch => 'customgradients'
    pod 'SkeletonView'
    pod 'CRRefresh'
    
    #TextField
    pod 'SkyFloatingLabelTextField', '~> 3.6.0'
    
    #UITextView
    pod 'KMPlaceholderTextView', '~> 1.4.0'
    
    # login library
    pod 'FBSDKLoginKit', '5.5.0'
    pod 'FBSDKCoreKit', '5.5.0'
    pod 'GoogleSignIn', '5.0.2'
    
    # google maps
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    
    # star rating library
    pod 'Cosmos', '18.0.1'
    
    #gallery
    pod 'DKImagePickerController', '4.1.2', :subspecs => ['PhotoGallery', 'Camera']
    
    #side menu
    pod 'LGSideMenuController', '2.1.1'
    
    #slider
    pod 'TTRangeSlider'
    
    #chat
    pod 'SendBirdSDK'
    pod 'MessageKit', '3.0.0'
    
    #crashlytics
    pod 'Fabric'
    pod 'Crashlytics'
    pod ‘Firebase/Core’
    
    #encrypt
    pod 'CryptoSwift', '0.15.0'
    
    #pagecontrol

    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
        installer.pods_project.targets.each do |target|
          # Cache pod does not accept optimization level '-O', causing Bus 10 error. Use '-Osize' or '-Onone'
          if target.name == 'Cache'
            target.build_configurations.each do |config|
              level = '-Osize'
              config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = level
              puts "Set #{target.name} #{config.name} to Optimization Level #{level}"
            end
          end
        end
    end
  
end
