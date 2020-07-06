# Uncomment the next line to define a global platform for your project
 platform :ios, '13.4'

def shared_pods
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher', '~> 5.0'
end

target 'FawksAdmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FawksAdmin
  shared_pods
  pod 'CropViewController'

end

target 'FawksCompany' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FawksCompany
  shared_pods
  pod 'Stripe', '~> 19.0.1'

end
