

Pod::Spec.new do |spec|

  spec.name         = "YXCategoryGroup"
  spec.version      = "0.0.1"
  spec.summary      = "all kinds of categories for iOS develop"
  spec.description  = <<-DESC
                      this project provide all kinds of categories for iOS developer 
                   DESC
  spec.homepage     = "https://github.com/yaohongxiao49/YXCategoryGroup"
  spec.license      = "MIT"
  spec.author             = { "JustBeliever" => "617146817@qq.com" }
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/yaohongxiao49/YXCategoryGroup.git", :tag => "0.0.1" }
  spec.source_files  = "YXCategoryGroupTest", "YXCategoryGroupTest/YXCategorys/**/*.{h，m}"
  spec.exclude_files = "Classes/Exclude"
  spec.public_header_files = "YXCategoryGroupTest/YXClassesReferencePCH.pch", "YXCategoryGroupTest/YXCategorys/**/*.h"
  spec.requires_arc = true

end
