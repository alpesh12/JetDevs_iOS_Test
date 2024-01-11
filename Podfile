platform :ios, '14.5'
use_frameworks!

inhibit_all_warnings!

target 'JetDevsHomeWork' do
  pod 'RxSwift', '~> 6.5'
  pod 'RxCocoa', '~> 6.5'
  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'SnapKit'

  target 'JetDevsHomeWorkTests' do
    inherit! :search_paths
  end

  target 'JetDevsHomeWorkUITests' do
    inherit! :complete
  end  

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.5'
    end
  end
end
