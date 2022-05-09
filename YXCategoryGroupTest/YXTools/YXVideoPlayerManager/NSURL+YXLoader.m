//
//  NSURL+YXLoader.m
//  MuchProj
//
//  Created by Augus on 2022/1/14.
//

#import "NSURL+YXLoader.h"

@implementation NSURL (YXLoader)

- (NSURL *)customSchemeURL {
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)originalSchemeURL {
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
