//
//  ListViewController.m
//  ZZDownloadManager
//
//  Created by 赵铭 on 2018/11/16.
//  Copyright © 2018年 zm. All rights reserved.
//

#import "ListViewController.h"
#import "ZZDownloadManager.h"
#import "ZZDownloadModelManager.h"
#import "ZZDownloadManager.h"
@interface ListModel : NSObject
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) int state;
@end

@implementation ListModel

@end


@interface ListViewController ()
@property (nonatomic, strong) NSMutableArray  * models;

@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _models = @[@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg", @"http://vjs.zencdn.net/v/oceans.mp4", @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", @"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4", @"http://221.228.226.23/11/t/j/v/b/tjvbwspwhqdmgouolposcsfafpedmb/sh.yinyuetai.com/691201536EE4912BF7E4F1E2C67B8119.mp4", @"http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4", @"http://www.live555.com/liveMedia/public/264/tc10.264", @"http://www.live555.com/liveMedia/public/264/slamtv60.264", @"http://www.live555.com/liveMedia/public/264/slamtv10.264"].mutableCopy;

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight=44;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    UILabel *lable1 = [cell.contentView viewWithTag:100];
    NSString *url = _models[indexPath.row];
    
    lable1.text = url;
    
    UILabel *lable2 = [cell.contentView viewWithTag:101];
    if ([[ZZDownloadManager shareManager] isInDownloadList:url]) {
        lable2.text = @"在下载列表中";

    }else if([[ZZDownloadManager shareManager] isFinishedDownload:url]){
        lable2.text = @"下载完成";
    }else{
        lable2.text = @"还没有下载,点击开始下载";
    }
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = _models[indexPath.row];
    if ([[ZZDownloadManager shareManager] isInDownloadList:url]) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"在下载列表中" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [a show];
    }else if([[ZZDownloadManager shareManager] isFinishedDownload:url]){
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"下载完成" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [a show];
        
    }else{
//        ZZDownloadModel *downloadModel = [[ZZDownloadManager shareManager] startDownload:url];
        ZZDownloadModel *downloadModel = [[ZZDownloadManager shareManager] addDownloadModelWithURL:url ];
        if (downloadModel) {
            [tableView reloadData];
        }
    }

}

- (IBAction)pushDownloadViewController:(id)sender {
    
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
