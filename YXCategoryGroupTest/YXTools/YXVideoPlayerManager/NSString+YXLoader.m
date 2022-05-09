//
//  NSString+YXLoader.m
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import "NSString+YXLoader.h"

@implementation NSString (YXLoader)

+ (NSString *)tempFilePath {
    
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"MusicTemp.mp4"];
}


+ (NSString *)cacheFolderPath {
    
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"MusicCaches"];
}

+ (NSString *)fileNameWithURL:(NSURL *)url {
    
    return [[url.path componentsSeparatedByString:@"/"] lastObject];
}

@end
