//
//  ZZDownloadOperation.h
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/7.
//  Copyright © 2018年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZDownloadOperation : NSOperation
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong, readonly) NSURLSessionDownloadTask *downloadTask;
@end
