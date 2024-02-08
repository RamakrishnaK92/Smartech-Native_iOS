# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Smartech Demo' do
  
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  
  # Pods for Smartech Demo
  pod 'Smartech-iOS-SDK'
  pod 'SmartPush-iOS-SDK'
  
  pod 'SmartechNudges', '9.0.6'
  #pod 'SmartechNudges', :path => '~/Downloads/SmartechNudges-PO1159'
  pod 'SmartechAppInbox-iOS-SDK'
  
  pod 'IQKeyboardManagerSwift'
  #pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'GoogleSignIn'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
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
    
    pod 'SmartPush-iOS-SDK'
    
  end
  
  #content extension target
  target 'SmartechNC' do
    #  ###
    use_frameworks!
    #  # Pods for 'YourContentExtensionTarget'
    
    pod 'SmartPush-iOS-SDK'
    
  end



