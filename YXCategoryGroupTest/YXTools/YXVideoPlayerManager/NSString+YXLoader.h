//
//  NSString+YXLoader.h
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YXLoader)

/** 临时文件路径 */
+ (NSString *)tempFilePath;

/** 缓存文件夹路径 */
+ (NSString *)cacheFolderPath;

/** 获取网址中的文件名 */
+ (NSString *)fileNameWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
