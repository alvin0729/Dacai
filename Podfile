source 'https://github.com/CocoaPods/Specs.git'

platform:ios, '7.0'
inhibit_all_warnings!

# https://github.com/Cocoapods/pull/1294
#xcodeproj 'Jackpot', 'Debug' => :debug, 'Release' => :release, 'Adhoc' => :release

def common_pods
    pod 'MSWeakTimer', '~> 1.1.0'
    pod 'MMWormhole', '~> 1.2.0'
end

target :'Jackpot' do
    pod 'Masonry', '~> 0.6.3'
    pod 'AFNetworking', '~> 2.5.4'
    pod 'ReactiveCocoa' ,'~> 2.5'
    pod 'MBProgressHUD', '~> 0.9.1'
    pod 'SSKeychain', '~> 1.2.3'
    pod 'SevenSwitch', '~> 1.4.0'
    pod 'NJKWebViewProgress', '~> 0.2.3'
    pod 'NSAttributedString-DDHTML', '~> 1.1.0'

    pod 'OAStackView', '~> 0.1.0'
    pod 'JLRoutes', '~> 1.5.3'
    
    #pod 'DZNEmptyDataSet', '~> 1.7.1'
    pod 'DZNEmptyDataSet', :git => 'https://github.com/flicker317/DZNEmptyDataSet.git', :branch => 'v1.7.1_fix'

    #pod 'MTStringAttributes', '~> 0.1.0'
    pod 'OHHTTPStubs', :configuration => ['Debug']
    pod 'MTStringAttributes', :git => 'https://github.com/flicker317/MTStringAttributes.git', :branch => 'master'
    pod 'Protobuf', '~> 3.0.0-alpha-3'
    pod 'WeiboSDK', :git => 'https://github.com/sinaweibosdk/weibo_ios_sdk.git'

    common_pods
end

target :'Jackpot WatchKit Extension' do
    common_pods
end
