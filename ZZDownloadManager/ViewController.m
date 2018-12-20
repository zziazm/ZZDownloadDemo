//
//  ViewController.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/7.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "AFNetworkReachabilityManager.h"
#import "ZZDownloadOperation.h"
#import "ZZDownloadManager.h"
#import "ZZDownloadModel.h"

@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, assign) BOOL pause;
@property (nonatomic) Reachability *hostReachability;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) ZZDownloadModel *model;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (IBAction)test:(id)sender {
    if (_task) {
        return;
    }
    NSURLSessionDownloadTask *task = [_session downloadTaskWithURL:[NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg"]];
    _task = task;
    _progressView.progress = 0;
}

- (IBAction)resume:(id)sender {
    if (_task.state == NSURLSessionTaskStateSuspended) {
        [_task resume];
    }else{
        if (self.resumeData) {
            self.task = [_session downloadTaskWithResumeData:_resumeData];
            [self.task resume];
        }
    }
}

- (IBAction)suspend:(id)sender {
    if (_task.state == NSURLSessionTaskStateRunning) {
        [_task suspend];
    }
}

- (IBAction)cancel:(id)sender {
    if (_task) {
        [_task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
        }];
        _progressView.progress = 0;
        _label.text = @"0";
    }
}

- (NSString *)cachePath{
    return  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}
- (IBAction)createsession:(id)sender {
    NSURLSessionConfiguration *c = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"background"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:c delegate:self delegateQueue:nil];
    _session = session;
//    NSArray *array =  [self sessionDownloadTasks];
//    if (array.count > 0) {
//        _task = array[0];
//        @"";
//    }else{
//
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressView.progress = 0;
   

}
- (NSArray *)sessionDownloadTasks
{
    __block NSArray *tasks = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);//使用信号量把异步变同步，是这个函数返回时tasks有值
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        tasks = downloadTasks;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return tasks;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
    if (resumeData) {
        self.resumeData = resumeData;
    }
    if (error) {
        // check if resume data are available
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
//            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            _task = [[ZZDownloadManager shareManager] downloadTaskWithResumeData:resumeData progress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//                CGFloat a = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _label.text = [NSString stringWithFormat:@"%.2f", a*100];
//                    [_progressView setProgress:a];
//                });
//            } completionHandler:^(NSError *error) {
//                _task = nil;
//            }];
//        }
    }
}
///* Sent when a download task that has completed a download.  The delegate should
// * copy or move the file at the given location to a new location as it will be
// * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
// * still be called.
// */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"%s", __func__);

}
//
//
//
///* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%s", __func__);
    CGFloat a = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.text = [NSString stringWithFormat:@"%.2f%%", a*100];
        [_progressView setProgress:a];
    });

}
//
///* Sent when a download has been resumed. If a download failed with an
// * error, the -userInfo dictionary of the error will contain an
// * NSURLSessionDownloadTaskResumeData key, whose value is the resume
// * data.
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes{
//    NSLog(@"%s", __func__);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)netChange:(NSNotification *)notification{
    Reachability *r = notification.object;
    NSLog(@"dddddddddddd = %ld", (long)r.currentReachabilityStatus);
    
}



@end
