//
//  ZZDownloadingCell.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/12/3.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ZZDownloadingCell.h"
#import "ZZDownloadManager.h"
@implementation ZZDownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = sender;
    [[ZZDownloadManager shareManager].session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionDownloadTask *task in downloadTasks) {
            NSLog(@"");
            
        }
    }];
    if (_model.state == ZZDownloadModelPauseState) {
        [[ZZDownloadManager shareManager] resumeDownload:_model];

//        [[ZZDownloadManager shareManager] resumeDownload:_model];
        [btn setTitle:@"下载中" forState:UIControlStateNormal];
    }
   else if (_model.state == ZZDownloadModelWillStartState) {
        [[ZZDownloadManager shareManager] resumeDownload:_model];
        [btn setTitle:@"下载中" forState:UIControlStateNormal];
    }
    
   else if (_model.state == ZZDownloadModelRunningState){
        [[ZZDownloadManager shareManager] pauseDownload:_model];
        [btn setTitle:@"暂停中" forState:UIControlStateNormal];
    }
}


- (void)setModel:(ZZDownloadModel *)model{
    _model = model;
    [self updateUI:model];
    __weak ZZDownloadingCell *weakCell = self;
    __weak ZZDownloadModel *weakModel = model;
    
    [model setProgressInfoBlock:^(ZZDownloadProgress *progress) {
        if (weakCell.model == weakModel) {
            [weakCell updateUI:weakModel];
        }
       
    }];
    if (_model.state == ZZDownloadModelPauseState) {
        [self.button setTitle:@"暂停中" forState:UIControlStateNormal];
    }
    else if (_model.state == ZZDownloadModelWillStartState){
        [self.button setTitle:@"准备下载" forState:UIControlStateNormal];
    }
    else {
        [self.button setTitle:@"下载中" forState:UIControlStateNormal];
    }
}

- (void)updateUI:(ZZDownloadModel *)model{
    
    self.fileNameLabel.text = model.fileName;
    self.progressView.progress = model.progress.progress;
    if ( model.progress.totalBytesWritten != 0) {
        self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", model.progress.writtenFileSize, model.progress.totalFileSize];
    }
    if (model.state == ZZDownloadModelPauseState || model.state == ZZDownloadModelWillStartState) {
        self.speedLabel.text = @"";
    }else{
        self.speedLabel.text = [NSString stringWithFormat:@"%@/s time:%d s", model.progress.speedString, model.progress.remainingTime];
    }
    
    if (_model.state == ZZDownloadModelPauseState) {
        [self.button setTitle:@"暂停中" forState:UIControlStateNormal];
    }
    else if (_model.state == ZZDownloadModelWillStartState){
        [self.button setTitle:@"准备下载" forState:UIControlStateNormal];
    }
    else {
        [self.button setTitle:@"下载中" forState:UIControlStateNormal];
    }
    

}

//- (void)configureModel:(ZZDownloadModel *)model tableView:(UITableView *)tableView{
//     NSArray *cellArr = [tableView visibleCells];
//     for (id obj in cellArr) {
//        if([obj isKindOfClass:[ZZDownloadingCell class]]) {
//            ZZDownloadingCell *cell = (ZZDownloadingCell *)obj;
//            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
//                cell.fileInfo = fileInfo;
//            }
//        }
//     }
//}

@end
