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
    
    NSString *url = super.request.URL.resourceSpecifier; //得到 //imgName.png
    //去掉 //的前缀
    url = [url substringFromIndex:2]; //imgName.png
    
    //若是app协议 需要添加xxx
    if ([super.request.URL.scheme caseInsensitiveCompare:@"appName"]) {
        url = [[NSString alloc] initWithFormat:@"xxx/%@", url];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:nil]; //这里是获取本地资源路径 如 ：png,js 等
    if (!path) return;
    
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    
    if (type != NULL) CFRelease(type);
    
    //这里需要用到MIMEType
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL    MIMEType:mimeType expectedContentLength:-1 textEncodingName:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];//加载本地资源
    
    //硬编码 开始嵌入本地资源到web中
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

#pragma mark - 停止加载
- (void)stopLoading {
    
}

@end
