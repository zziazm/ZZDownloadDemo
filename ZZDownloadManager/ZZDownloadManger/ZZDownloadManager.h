//
//  ZZDownloadManager.h
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/9.
//  Copyright © 2018年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZDownloadModel.h"

@interface ZZDownloadedFile:NSObject

@property (nonatomic, copy) NSString        *fileName;
/** 文件的总长度 */
@property (nonatomic, copy) NSString        *fileSize;

@property (nonatomic, copy) NSString        *filePath;

@property (nonatomic, copy) NSString        *fileType;

@end


@interface ZZDownloadManager : NSObject

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, strong) NSMutableArray <ZZDownloadModel *> * downloadModelList;
@property (atomic, strong) NSMutableArray  <ZZDownloadedFile *> *finishedlist;
@property (nonatomic, strong) NSMutableDictionary *downloadModelDic;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger downloadingCount;


+(ZZDownloadManager *)shareManager;

- (ZZDownloadModel *)addDownloadModelWithURL:(NSString *)url;


- (void)saveDownloadInfo:(ZZDownloadModel *)model;


//是否在下载的列表里
- (BOOL)isInDownloadList:(NSString *)url;
- (BOOL)isFinishedDownload:(NSString *)url;

//- (ZZDownloadModel *)startDownload:(NSString *)url;



- (void)deleteDownload:(ZZDownloadModel *)model;
- (void)resumeDownload:(ZZDownloadModel *)model;
- (void)pauseDownload:(ZZDownloadModel *)model;
- (void)deleteFinishFile:(ZZDownloadedFile *)model;
@end
