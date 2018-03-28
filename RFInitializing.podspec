Pod::Spec.new do |s|
  s.name             = 'RFInitializing'
  s.version          = '1.0.0'
  s.summary          = 'Make object initialization easier. Stop writing init methods again and again.'

  s.homepage         = 'https://github.com/RFUI/RFInitializing'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BB9z' => 'bb9z@me.com' }
  s.source           = { :git => 'https://github.com/RFUI/RFInitializing.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.6'
  s.ios.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = [ 'RFInitializing.h' ]
  s.public_header_files = [ 'RFInitializing.h' ]
end
