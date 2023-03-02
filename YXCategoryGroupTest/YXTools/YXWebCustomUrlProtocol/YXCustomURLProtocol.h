//
//  YXCustomURLProtocol.h
//  MuchProj
//
//  Created by Augus on 2023/3/2.
//
/// 使用方法：
/// [NSURLProtocol registerClass:[YXCustomURLProtocol class]];
/// [YXCustomURLProtocol supportURLProtocol];

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCustomURLProtocol : NSURLProtocol

@property (nonatomic, strong) NSURLRequest *urlRequest;

#pragma mark - 自定义WKWebView劫持
+ (void)supportURLProtocol;

@end

NS_ASSUME_NONNULL_END
