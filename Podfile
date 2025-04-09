# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Smartech Demo' do
  
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  
  # Pods for Smartech Demo
  pod 'Smartech-iOS-SDK', '~> 3.6.1
  '
  pod 'SmartPush-iOS-SDK', '~> 3.5.5'
  pod 'SmartechNudges', '9.0.17'
  pod 'SmartechAppInbox-iOS-SDK', '~> 3.5.6'
  
  pod 'IQKeyboardManagerSwift'
  #pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'GoogleSignIn'
  pod 'GoogleTagManager'
  
  pod 'AppsFlyerFramework'  #appsflyer SDK
  pod 'MoEngage-iOS-SDK'
  pod 'Alamofire'

  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        
      end
    end
  end
  
end
  
  ### #service extension target
  target 'SmartechNSE' do
    ###
    use_frameworks!
    # Pods for 'YourServiceExtensionTarget'
    
    pod 'SmartPush-iOS-SDK', '~> 3.5.5'

  end
  
  #content extension target
  target 'SmartechNC' do
    #  ###
    use_frameworks!
    #  # Pods for 'YourContentExtensionTarget'
    
    pod 'SmartPush-iOS-SDK', '~> 3.5.5'

  end



