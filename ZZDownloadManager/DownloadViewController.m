//
//  DownloadViewController.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/19.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "DownloadViewController.h"
#import "ZZDownloadModelManager.h"
#import "ZZDownloadModel.h"
#import "ZZDownloadManager.h"
#import "ZZDownloadingCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface DownloadViewController ()<UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight=44;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"最大下载数" style:UIBarButtonItemStylePlain target:self action:@selector(selectMaxCount)];
    
 self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self initData];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)selectMaxCount{
    UIActionSheet * s = [[UIActionSheet alloc] initWithTitle:@"选择同时下载数" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destructive" otherButtonTitles:@"1", @"2", @"3", @"4", nil];
    [s showInView:self.view];
}
- (void)initData{
    _models = @[[ZZDownloadManager shareManager].finishedlist,[ZZDownloadManager shareManager].downloadModelList].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_models[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadFinishedCell" forIndexPath:indexPath];
        UILabel *fileName = [cell.contentView viewWithTag:100];
        UILabel *fileSize = [cell.contentView viewWithTag:101];
        ZZDownloadedFile *model = _models[indexPath.section][indexPath.row];
        fileName.text = model.fileName;
        fileSize.text = model.fileSize;
        return cell;
    }
    
    ZZDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    ZZDownloadModel *model = _models[indexPath.section][indexPath.row];
    cell.model = model;
    __weak DownloadViewController * weakSelf = self;
    [model setCompleteBlock:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
    // Configure the cell...
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"下载完成";
    }else{
        return @"下载中";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZDownloadedFile *file = _models[indexPath.section][indexPath.row];
        [self playWithPath:file.filePath];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ZZDownloadedFile *model = _models[indexPath.section][indexPath.row];
        [[ZZDownloadManager shareManager] deleteFinishFile:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];    }
    
    if (indexPath.section == 1) {
        ZZDownloadModel *model = _models[indexPath.section][indexPath.row];
        [[ZZDownloadManager shareManager] deleteDownload:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
    }
}

- (void)playWithPath:(NSString *)path{
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController*playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
    [playerViewController.player play];
}


#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger maxCount = buttonIndex;
    [ZZDownloadManager shareManager].maxCount = maxCount;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
