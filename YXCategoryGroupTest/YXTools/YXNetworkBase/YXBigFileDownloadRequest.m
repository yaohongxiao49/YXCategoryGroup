//
//  YXBigFileDownloadRequest.m
//  MuchProj
//
//  Created by Augus on 2023/3/13.
//

#import "YXBigFileDownloadRequest.h"
#import "YXToolGetSandbox.h"

@interface YXBigFileDownloadRequest () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 记录下载位置 */
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation YXBigFileDownloadRequest

#pragma mark - 单例
+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static YXBigFileDownloadRequest *instance;
    dispatch_once(&onceToken, ^{
        
        instance = [[YXBigFileDownloadRequest alloc] init];
    });
    return instance;
}

#pragma mark - 开始下载
- (void)startDownloadByFileUrl:(NSString *)fileUrl {
    
    NSURL *url = [NSURL URLWithString:fileUrl];
    //创建任务
    self.downloadTask = [self.session downloadTaskWithURL:url];
    //开始任务
    [self.downloadTask resume];
}

#pragma mark - 恢复下载
- (void)resumeDownload {
    
    //传入上次暂停下载返回的数据，就可以恢复下载
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    //开始任务
    [self.downloadTask resume];
    self.resumeData = nil;
}

#pragma mark - 暂停下载
- (void)pauseDownload {
    
    __weak typeof(self) weakSelf = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        
        //resumeData : 包含了继续下载的开始位置\下载的url
        weakSelf.resumeData = resumeData;
        weakSelf.downloadTask = nil;
    }];
}

#pragma mark - 解压文件
- (void)yxOpenZipByPath:(NSString *)path unzipto:(NSString *)unzipto openZipBlock:(void(^)(NSInteger progress, NSString *unzipPath))openZipBlock {
    
    //压缩文件
    ZipArchive *zip = [[ZipArchive alloc] init];
    zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles) {
        
        openZipBlock(percentage, unzipto);
    };
    //压缩文件路径
    NSString *zipFile = path;
    //解压缩
    //创建解压位置
    NSString *unZipFile = unzipto;
    BOOL unZipReady = [zip UnzipOpenFile:zipFile];
    if (unZipReady) {
        BOOL ret = [zip UnzipFileTo:unZipFile overWrite:YES];
        if (!ret) {
            NSLog(@"解压文件失败：%@", zipFile);
        }
        [zip CloseZipFile2];
    }
    else {
        NSAssert(false, @"请更换压缩路径或者解压路径");
    }
}

#pragma mark - 压缩文件
- (void)yxZipFileByPath:(NSString *)path zipToPath:(NSString *)zipToPath {
    
    //压缩文件
    ZipArchive *zip = [[ZipArchive alloc] init];
    //压缩文件路径
    NSString *zipFile = zipToPath;
    //该路径创建一个压缩文件
    BOOL isReady = [zip CreateZipFile2:zipToPath];
    if (isReady) {
        NSLog(@"压缩文件夹创建成功");
        //将内容压缩至压缩文件中
        NSString *path = [[NSBundle mainBundle] pathForResource:@"path" ofType:nil];
        [zip addFileToZip:path newname:@"path"];
        //关闭压缩
        [zip CloseZipFile2];
    }
    else {
        NSAssert(false, @"请更换压缩路径");
    }
}

#pragma mark - 移除压缩文件
- (void)removeZipMethodByPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *file in fileList) {
        if ([file containsString:@".zip"]) {
            NSString *pathFile = [NSString stringWithFormat:@"%@/%@", path, file];
            [YXToolLocalSaveBySqlite yxRemoveFileByPath:pathFile];
            _openZipPath = [pathFile stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        }
    }
}

#pragma mark - <NSURLSessionDownloadDelegate>
#pragma mark - 下载完毕会调用，location文件临时地址
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    //将临时文件剪切或者复制Caches文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //判断如果有文件夹则不创建，如果没有则创建新的文件夹，
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *saveFile = [NSString stringWithFormat:@"%@/%@", caches, [infoDic objectForKey:@"CFBundleDisplayName"]];
    [YXToolGetSandbox yxHasLive:saveFile];
    
    //response.suggestedFilename : 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [saveFile stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //AtPath : 剪切前的文件路径
    //ToPath : 剪切后的文件路径
    [fileManager moveItemAtPath:location.path toPath:file error:nil];
    
    //提示下载完成
    if (self.yxBigFileDownloadRequestBlock) {
        self.yxBigFileDownloadRequestBlock(file, downloadTask.response.suggestedFilename);
    }
}

#pragma mark - 每次写入沙盒完毕调用，监听下载进度，totalBytesWritten/totalBytesExpectedToWrite；bytesWritten：这次写入的大小；totalBytesWritten：已经写入沙盒的大小；totalBytesExpectedToWrite：文件总大小
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    double progressValue = (double)totalBytesWritten/totalBytesExpectedToWrite;
    if (self.yxBigFileDownloadRequestProgressBlock) {
        self.yxBigFileDownloadRequestProgressBlock(progressValue);
    }
}

#pragma mark - 恢复下载后调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

#pragma mark - 懒加载
- (NSURLSession *)session {
    
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
