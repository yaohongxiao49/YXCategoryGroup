//
//  YXCustomURLProtocol.m
//  MuchProj
//
//  Created by Augus on 2023/3/2.
//

#import "YXCustomURLProtocol.h"

@implementation YXCustomURLProtocol

#pragma mark - 比较地址与app名
+ (BOOL)initWithRequest:(NSURLRequest *)theRequest {
    
    if ([theRequest.URL.scheme caseInsensitiveCompare:@"appName"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)theRequest {
    
    return theRequest;
}

#pragma mark - 开始加载
- (void)startLoading {
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.urlRequest URL] MIMEType:@"image/png" expectedContentLength:-1 textEncodingName:nil];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

#pragma mark - 停止加载
- (void)stopLoading {
    
}

@end
