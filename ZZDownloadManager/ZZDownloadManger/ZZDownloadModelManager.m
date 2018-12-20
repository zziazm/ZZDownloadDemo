//
//  ZZManager.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/19.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ZZDownloadModelManager.h"
#import "ZZDownloadModel.h"
#import "ZZDownloadManager.h"

@implementation ZZDownloadModelManager

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static ZZDownloadModelManager * manager;
    dispatch_once(&onceToken, ^{
        manager = [ZZDownloadModelManager new];
        
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        _downloadingModels = @[].mutableCopy;
    }
    return self;
}

//- (ZZDownloadModel *)startDownload:(NSString *)url{
//    ZZDownloadModel *model = [[ZZDownloadModel alloc] initWithUrl:url];
//    [model startDownload];
//    [_downloadingModels addObject:model];
//    return model;
//}

- (ZZDownloadModel *)downloadTaskWithUrl:(NSString *)url
                                         progress:(ZZDownloadProgressBlock) progress
                                completionHandler:(void(^)(NSError *error))completionHandler{
    ZZDownloadModel *model = [ZZDownloadModel new];
//    model.url = url;
    //    NSURLSessionDownloadTask *task = [[ZZDownloadManager shareManager] downloadTaskWithUrl:url progress:progress completionHandler:completionHandler];
    //    model.downloadTask = task;
    
    return nil;
    
}



@end
