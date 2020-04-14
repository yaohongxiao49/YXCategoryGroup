#http://guides.cocoapods.org/syntax/podspec.html 命名说明

Pod::Spec.new do |spec|

  spec.name                = "YXCategoryGroup" #跟文件名保持一致
  spec.version             = "0.1.2"
  spec.summary             = "基础数据类型的分类集合"
  spec.description         = <<-DESC
                             this project provide all kinds of categories for iOS developer 
                          DESC
  spec.homepage            = "https://github.com/yaohongxiao49/YXCategoryGroup"
  spec.license             = { :type => "MIT", :file => "LICENSE" }
  spec.author              = { "JustBeliever" => "617146817@qq.com" }
  spec.platform            = :ios, "10.0"
  spec.source              = { :git => "https://github.com/yaohongxiao49/YXCategoryGroup.git", :tag => "#{spec.version}"}

  spec.subspec 'YXCategorys' do |s|
    s.source_files        = "YXCategoryGroupTest/YXCategorys/**/*.{h,m}"
    s.public_header_files = "YXCategoryGroupTest/YXCategorys/**/*.h"
  end

  spec.subspec 'YXTools' do |s|
    s.source_files        = "YXCategoryGroupTest/YXTools/**/*.{h,m}"
    s.public_header_files = "YXCategoryGroupTest/YXTools/**/*.h"
  end

  spec.exclude_files       = "Classes/Exclude"
  spec.requires_arc        = true

end
