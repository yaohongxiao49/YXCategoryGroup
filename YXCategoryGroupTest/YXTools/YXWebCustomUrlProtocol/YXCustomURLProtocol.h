//
//  YXCustomURLProtocol.h
//  MuchProj
//
//  Created by Augus on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCustomURLProtocol : NSURLProtocol

@property (nonatomic, strong) NSURLRequest *urlRequest;

/** 比较地址与app名 */
+ (BOOL)initWithRequest:(NSURLRequest *)theRequest
                appName:(NSString *)appName;

@end

NS_ASSUME_NONNULL_END
