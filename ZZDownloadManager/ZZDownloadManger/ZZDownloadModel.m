//
//  ZZDownloadModel.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/8.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ZZDownloadModel.h"
#import <UIKit/UIKit.h>
#import "ZZDownloadManager.h"
#import "ZZDownloadModelManager.h"


@interface ZZDownloadProgress ()
// 续传大小
@property (nonatomic, assign) int64_t resumeBytesWritten;
// 这次写入的数量
@property (nonatomic, assign) int64_t bytesWritten;
// 已下载的数量
//@property (nonatomic, assign) int64_t totalBytesWritten;
//// 文件的总大小
//@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;

// 下载进度
@property (nonatomic, assign) float progress;
// 下载速度
@property (nonatomic, assign) float speed;
// 下载剩余时间
@property (nonatomic, assign) int remainingTime;

@property (nonatomic, copy) NSString * speedString;

@end

@implementation ZZDownloadProgress
- (float)progress{
    if (_totalBytesWritten == 0) {
        return 0;
    }
    return (CGFloat)_totalBytesWritten/_totalBytesExpectedToWrite;
}

- (NSString *)writtenFileSize{
    NSString *writtenFileSize = [NSString stringWithFormat:@"%.2f %@",
                                 [self calculateFileSizeInUnit:(unsigned long long)self.totalBytesWritten],
                                 [self calculateUnit:(unsigned long long)self.totalBytesWritten]];
    
    return writtenFileSize;

}

- (NSString *)totalFileSize{
    NSString *totalFileSize = [NSString stringWithFormat:@"%.2f %@",
                                     [self calculateFileSizeInUnit:(unsigned long long)self.totalBytesExpectedToWrite],
                                     [self calculateUnit:(unsigned long long)self.totalBytesExpectedToWrite]];
    return totalFileSize;
}

- (NSString *)speedString{
    NSString *speedS = [NSString stringWithFormat:@"%.2f %@",[self calculateFileSizeInUnit:(unsigned long long)self.speed],
                        [self calculateUnit:(unsigned long long)self.speed]];
    return speedS;
}

- (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
        return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
        return (float) (contentLength / (float)1024);
    else
        return (float) (contentLength);
}

- (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return @"GB";
    else if(contentLength >= pow(1024, 2))
        return @"MB";
    else if(contentLength >= 1024)
        return @"KB";
    else
        return @"Bytes";
}
@end






@interface ZZDownloadModel()<NSURLSessionDelegate>
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, assign) int64_t bytes;

@end


@implementation ZZDownloadModel

- (instancetype)initWithURL:(NSString *)url{
    if (!url) {
        return nil;
    }
    if ([[ZZDownloadManager shareManager] isFinishedDownload:url] || [[ZZDownloadManager shareManager] isInDownloadList:url]) {
        return nil;
    }
    self = [super init];
    if (self) {
        NSURLSessionDownloadTask *task = [[ZZDownloadManager shareManager].session downloadTaskWithURL:[NSURL URLWithString:url]];
        self.downloadTask = task;
        self.url = url;
        self.startTime = [self dateToString:[NSDate date]];
        _progress = [ZZDownloadProgress new];
    }
    return self;
}

//- (instancetype)initWithResumeData:(NSData *)resumeData
//                               url:(NSString *)url
//{
//    if (!resumeData) {
//        return nil;
//    }
//    if (self = [super init]) {
//        self.resumeData = resumeData;
//        _progress = [ZZDownloadProgress new];
//        self.url = url;
//    }
//    return self;
//}

- (NSString *)fileName{
    return [self.url lastPathComponent];
}
//- (instancetype)initWithUrl:(NSString *)url{
//    if (self = [super init]) {
//        _url = url;
//        _task = [[ZZDownloadManager shareManager] downloadTaskWithUrl:url progress:nil completionHandler:nil];
//
//    }
//    return self;
//}

- (instancetype)init{
    if (self = [super init]) {
        _progress = [ZZDownloadProgress new];
    }
//    if (self = [super init]) {
//
//    }
//    return self;
    return self;
}
//- (NSString *)url{
//    return self.downloadTask.currentRequest.URL.absoluteString;
//}

//- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task{
//    if (task == nil) {
//        return nil;
//    }
//    if (self = [super init]) {
//         _progress = [ZZDownloadProgress new];
//         _downloadTask = task;
//    }
//    return self;
//}

//- (void)startDownload{
//    if (self.state == ZZDownloadModelRunningState) {
//        return;
//    }
//    if (self.state == ZZDownloadModelWillStartState) {
//        if (self.resumeData) {
//            [self resume];
//        }else{
//            if (!_downloadTask) {
//                 _downloadTask = [[ZZDownloadManager shareManager].session downloadTaskWithURL:[NSURL URLWithString:_url]];
//            }
//            _state = ZZDownloadModelRunningState;
//            [self saveInfo];
//            _date = [NSDate date];
//            _bytes = 0;
//            [_downloadTask resume];
//
//        }
//    }
//}

- (void)saveInfo{
    [[ZZDownloadManager shareManager] saveDownloadInfo:self];
}

//- (void)downloadTaskWithProgress:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))progress
//               completionHandler:(void(^)(NSError *error))completionHandler{
////    _downloadTask = [[ZZDownloadManager shareManager] downloadTaskWithUrl:_url progress:progress completionHandler:completionHandler];
////    _downloadProgress = progress;
////    _downloadTask = [[ZZDownloadManager shareManager].session downloadTaskWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg"]];
////    [_downloadTask resume];
////    _state = ZZDownloadModelDownloadingState;
////    [ZZDownloadManager shareManager] downloadTaskWithUrl:_url progress:<#^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)progress#> cmpletionHandler:<#^(NSError *error)completionHandler#>
//}

//- (void)startDownload{
////    _downloadTask = [[ZZDownloader shareManager].session downloadTaskWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg"]];
////    [_downloadTask resume];
////    _state = ZZDownloadModelDownloadingState;
//}

#pragma mark -- NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
//    if (error) {
//        // check if resume data are available
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
//            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            if (resumeData) {
//                self.resumeData = resumeData;
//            }
//            //            NSURLSessionTask *task = [[self backgroundURLSession] downloadTaskWithResumeData:resumeData];
//            //            [task resume];
//        }
//        else{
//            self.state = ZZDownloadModelCompleteState;
//        }
//    }else{
//        self.state = ZZDownloadModelCompleteState;
//        
//    }
    
    
    if(self.completeBlock){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completeBlock(error);
        });
    }
}

#pragma mark -- NSURLSessionDownloadDelegate

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"%s", __func__);
   
}


/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%s", __func__);
    
    _progress.bytesWritten = bytesWritten;
    _progress.totalBytesWritten = totalBytesWritten;
    _progress.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
    
    _progress.progress = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
    
    NSDate *currentDate = [NSDate date];
    double time = [currentDate timeIntervalSinceDate:self.date];
    self.bytes = self.bytes + bytesWritten;
    if (time >= 1) {
        float speed  = _bytes/time;
        
        int64_t remainingContentLength = totalBytesExpectedToWrite - totalBytesWritten;
        int remainingTime = ceilf(remainingContentLength / speed);
        
        _progress.speed = speed;
        _progress.remainingTime = remainingTime;
        
        _date = currentDate;
        _bytes = 0;
    }
    
    if (self.progressInfoBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressInfoBlock(self.progress);
        });
    }
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"%s", __func__);
}

- (void)pause{
    if (self.state == ZZDownloadModelRunningState) {
        self.state = ZZDownloadModelPauseState;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {

        }];
    }
}
- (void)wait{
    if (self.state == ZZDownloadModelRunningState) {
        self.state = ZZDownloadModelWillStartState;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
        }];
    }
}

- (void)resume{
    
    if (self.state == ZZDownloadModelPauseState) {
        if (self.resumeData) {
           
            self.downloadTask = [[ZZDownloadManager shareManager].session downloadTaskWithResumeData:self.resumeData];
            [self.downloadTask resume];
            self.date = [NSDate date];
            self.state = ZZDownloadModelRunningState;
            [self saveInfo];
        }
    }
    
    if (self.state == ZZDownloadModelWillStartState) {
        if (self.resumeData) {
            self.downloadTask = [[ZZDownloadManager shareManager].session downloadTaskWithResumeData:self.resumeData];
            [self.downloadTask resume];
            self.date = [NSDate date];
            self.state = ZZDownloadModelRunningState;
            [self saveInfo];
        }else{
            if (!self.downloadTask) {
                self.downloadTask = [[ZZDownloadManager shareManager].session downloadTaskWithURL:[NSURL URLWithString:self.url]];

            }
            [self.downloadTask resume];
            self.date = [NSDate date];
            self.state = ZZDownloadModelRunningState;
            [self saveInfo];
        }
        
    }
    
}

- (void)cancel{
    [self.downloadTask cancel];
}


- (NSString *)dateToString:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    return datestr;
}

@end
