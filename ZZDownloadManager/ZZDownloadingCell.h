//
//  ZZDownloadingCell.h
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/12/3.
//  Copyright © 2018年 zm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZDownloadModel.h"
@interface ZZDownloadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) ZZDownloadModel *model;
//@property (nonatomic, weak) UITableView  *tableView;

//@property (nonatomic, strong) ZZDownloadProgress *progress;
@end
