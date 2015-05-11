//
//  YHPSNewStorePickViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-10-10.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHPSNewStorePickViewController.h"

@interface YHPSNewStorePickViewController ()
{
    NSDictionary * dict;
    NSInteger  selectRow;
}
@end

@implementation YHPSNewStorePickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        selectRow = 999;
        dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeInfo"];
    
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _popArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"选择自提门店";
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    
//    UIButton * leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftItem.frame = CGRectMake(7, 7, 30, 30);
//    [leftItem addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
//    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.leftBarButtonItems= BACKBARBUTTON(@"返回", @selector(back:));
    //  tableview
    popMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenSize.height-NAVBAR_HEIGHT) style:UITableViewStylePlain];
    popMenu.delegate = self;
    popMenu.dataSource = self;
    popMenu.showsVerticalScrollIndicator = NO;
    popMenu.backgroundColor =[PublicMethod colorWithHexValue:0xf8f8f8 alpha:1.0f];
    popMenu.backgroundView = nil;
    
    [popMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:popMenu];
    
    // 获取门店列表
    [[NetTrans getInstance] getBuList:self Page:@"1" Limit:@"10"];
    

}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --------------------UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _popArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *name = [PublicMethod addLabel:CGRectMake(10, 7, 285, 20) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:16]];
        name.tag = 1001;
        [cell.contentView addSubview:name];
        
        UILabel *description = [PublicMethod addLabel:CGRectMake(10, 27, 285, 19) setTitle:nil setBackColor:[UIColor blackColor] setFont:[UIFont systemFontOfSize:10]];
        description.tag = 1002;
        [cell.contentView addSubview:description];
        
        UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(290, 15, 20, 20)];
        arrow.tag = selectRow;
        [cell.contentView addSubview:arrow];
        
        UIView *darkLine = [PublicMethod addBackView:CGRectMake(0, 49, 320, 1) setBackColor:[UIColor lightGrayColor]];
        darkLine.alpha = .2f;
        [cell.contentView addSubview:darkLine];
    }
    
    BuListEntity *entity = [self.popArray objectAtIndex:indexPath.row];
    UILabel *name_tag = (UILabel *)[cell.contentView viewWithTag:1001];
    name_tag.text =entity.bu_name;
    
    UILabel *description_tag = (UILabel *)[cell.contentView viewWithTag:1002];
    description_tag.text =entity.address;
    //选择自提之后,优先默认自提门店;选择配送，而后选择自提，则走旧流程
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bu_name"] &&
//        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"] &&
//        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"] &&
//        [[NSUserDefaults standardUserDefaults] objectForKey:@"bu_address"]){
    
        if ([entity.bu_code isEqualToString:self.bu_code]) {
            UIImageView * arrow = (UIImageView *) [cell.contentView viewWithTag:selectRow];
            arrow.image = [UIImage imageNamed:@"tab_sel"];
        }
//    }else{
//        if ([entity.bu_code isEqualToString:[dict objectForKey:@"bu_code"]]) {
//            UIImageView * arrow = (UIImageView *) [cell.contentView viewWithTag:selectRow];
//            arrow.image = [UIImage imageNamed:@"tab_sel"];
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow = indexPath.row;
    self.listEntity = [_popArray objectAtIndex:indexPath.row];
    //更新库存门店等信息
    [self restoreDeliveryInfo:self.listEntity];
//        if (![self.listEntity.bu_code isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]]) {
//            [self restoreDeliveryInfo:self.listEntity];
//        }

    
    _storeDic = @{@"bu_id": self.listEntity.bu_id ,@"bu_name":self.listEntity.bu_name,@"bu_code":self.listEntity.bu_code,@"bu_address":self.listEntity.address};
//    selectStoreLabel.text =[NSString
//                            stringWithFormat:@"   %@",self.listEntity.bu_name];
    
//    NSDictionary *storeDic1 = @{@"bu_id": [self.storeDic objectForKey:@"bu_id"],@"bu_name":[self.storeDic objectForKey:@"bu_name"],@"bu_code":[self.storeDic objectForKey:@"bu_code"],@"bu_address":[self.storeDic objectForKey:@"bu_address"]};
//    [[NSUserDefaults standardUserDefaults] setObject:storeDic1 forKey:@"storeInfo"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.psStoreBlock([self.storeDic objectForKey:@"bu_id"],[self.storeDic objectForKey:@"bu_name"],[self.storeDic objectForKey:@"bu_code"],[self.storeDic objectForKey:@"bu_address"]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)restoreDeliveryInfo:(BuListEntity *)entity{
        
    //保存自提信息
    [[NSUserDefaults standardUserDefaults] setObject:entity.bu_code forKey:@"bu_code"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.bu_id forKey:@"bu_id"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.bu_name forKey:@"bu_name"];
    [[NSUserDefaults standardUserDefaults] setObject:entity.address forKey:@"bu_address"];
    
    //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_id"] forKey:@"region_id"];
    //        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_name"] forKey:@"region_name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"psStyle"];
    //清除配送信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_name"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------------  net
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_BUY_PLATFORM_BU_LIST) {
        [self.popArray removeAllObjects];
        [self.popArray addObjectsFromArray:(NSMutableArray *)netTransObj];
        [popMenu reloadData];
    }
            
            
            
//    // 上传默认时间戳
//    self.uploadTimeStr = [PublicMethod NSStringToNSDate:self.dateStringDefault];
//    NSLog(@"%lld",[self.uploadTimeStr longLongValue]);
//    selectInterval = [self.uploadTimeStr longLongValue];
    // 存储得门店
//    _storeDic = [[NSDictionary alloc] init];
//    self.storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeInfo"];
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
     [[iToast makeText:errMsg]show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
