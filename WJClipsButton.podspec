Pod::Spec.new do |s|
  s.name             = 'WJClipsButton'
  s.version          = '0.0.1'
  s.summary          = 'Clips button, free your hand anytime.'
  s.description      = <<-DESC
Clip to choose and pan to lock or unlock.
                       DESC

  s.homepage         = 'https://github.com/jingzhilehuakai/WJClipsButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jingzhilehuakai' => 'wj_jingzhilehuakai@163.com' }
  s.source           = { :git => 'https://github.com/jingzhilehuakai/WJClipsButton.git', :tag => s.version.to_s }
  s.social_media_url = 'http://jingzhilehuakai.com'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WJClipsButton/Classes/**/*'

  s.resource = "WJClipsButton/Resources/**/*.bundle"

end
