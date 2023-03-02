//
//  YXCustomURLProtocol.h
//  MuchProj
//
//  Created by Augus on 2023/3/2.
//
/// 通过 [NSURLProtocol registerClass:[YXNFTInteractionWebVC class]] 使用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCustomURLProtocol : NSURLProtocol

@property (nonatomic, strong) NSURLRequest *urlRequest;

+ (BOOL)initWithRequest:(NSURLRequest *)theRequest;

@end

NS_ASSUME_NONNULL_END
