//
//  ZZManager.h
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/19.
//  Copyright © 2018年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZDownloadProgress;
@class ZZDownloadModel;

typedef void(^ZZDownloadProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void(^ZZDownloadProgressInfoBlock)(ZZDownloadProgress *);
typedef void(^ZZDownloadCompleteBlock)(NSError * error);

@interface ZZDownloadModelManager : NSObject<NSURLSessionDownloadDelegate>

+ (instancetype)shareManager;

- (ZZDownloadModel *)startDownload:(NSString *)url;

@property (nonatomic, strong) NSMutableArray <ZZDownloadModel *> * downloadingModels;

@end
