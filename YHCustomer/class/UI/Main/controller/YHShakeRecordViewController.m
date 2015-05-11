//
//  YHShakeRecordViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-11-14.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHShakeRecordViewController.h"
#import "YHShakeAddressViewController.h"
#import "shakeEntity.h"

@interface YHShakeRecordViewController ()

@end

@implementation YHShakeRecordViewController
@synthesize dataArray = _dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.refreshHeaderView removeFromSuperview];
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.refreshHeaderView = nil;
    self._tableView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [self addRefreshTableFooterView];
    self.view.backgroundColor =[PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    self.navigationItem.title = @"摇奖记录";
    self.navigationItem.leftBarButtonItems= BACKBARBUTTON(@"返回", @selector(back:));
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClickMethod
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)address:(UIButton *)btn{
//    __unsafe_unretained YHShakeRecordViewController * vc = self;
    YHShakeAddressViewController * avc = [[YHShakeAddressViewController alloc]init ];
    avc.activityId = [[_dataArray objectAtIndex:btn.tag - 999] objectForKey:@"id"];
    avc.block = ^(NSString * name,NSString * mobile,NSString *address){
        [[NetTrans getInstance] shake_award_list:self page:@"1"];
        
    };
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifer = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    [cell.contentView removeAllSubviews];
     cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    UILabel * record = [PublicMethod addLabel:CGRectMake(10, 0, SCREEN_WIDTH-20, 25) setTitle:@"" setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
    record.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    record.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    record.tag = indexPath.row + 100;
    [cell.contentView addSubview:record];
    
    UILabel * time = [PublicMethod addLabel:CGRectMake(10, record.bottom , SCREEN_WIDTH-20, 25) setTitle:@"" setBackColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] setFont:[UIFont systemFontOfSize:12]];
    time.tag = indexPath.row + 500;
    time.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    time.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    [cell.contentView addSubview:time];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, time.bottom, SCREEN_WIDTH, 10)];
    line.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    [cell.contentView addSubview:line];
    
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];

    record.text = [NSString stringWithFormat:@"奖励：%@", [dict objectForKey:@"prize_title"]];
    time.text = [dict objectForKey:@"add_time"];
    if ([[dict objectForKey:@"prize_type"] isEqualToString:@"1"] || [[dict objectForKey:@"prize_type"] isEqualToString:@"2"]) {
        //
    }else if ([[dict objectForKey:@"prize_type"] isEqualToString:@"3"]){
        UILabel * info = [PublicMethod addLabel:CGRectMake(10, record.bottom ,100, 25) setTitle:@"快递地址" setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
        [cell.contentView addSubview:info];
        if ([[dict objectForKey:@"name"]length] && [[dict objectForKey:@"mobile"]length] && [[dict objectForKey:@"address"]length]) {
            UILabel * name = [PublicMethod addLabel:CGRectMake(10, info.bottom , SCREEN_WIDTH-20, 25) setTitle:[NSString stringWithFormat:@"姓名：%@",[dict objectForKey:@"name"]] setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
            UILabel * mobile = [PublicMethod addLabel:CGRectMake(10, name.bottom , SCREEN_WIDTH-20, 25) setTitle:[NSString stringWithFormat:@"电话：%@",[dict objectForKey:@"mobile"]] setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
            UILabel * address = [PublicMethod addLabel:CGRectMake(10, mobile.bottom +4 , SCREEN_WIDTH -10, 60) setTitle:[NSString stringWithFormat:@"详细地址：%@",[dict objectForKey:@"address"]] setBackColor:nil setFont:[UIFont systemFontOfSize:15]];
            address.numberOfLines = 0;
            
            //设置行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:address.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:7];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [address.text length])];
            address.attributedText = attributedString;
            [address sizeToFit];

//            CGSize size = [address.text sizeWithFont:address.font constrainedToSize:CGSizeMake(address.frame.size.width, 50) lineBreakMode:NSLineBreakByWordWrapping];
//            address.frame = CGRectMake(10, mobile.bottom , SCREEN_WIDTH -20, size.height);
            [cell.contentView addSubview:name];
            [cell.contentView addSubview:mobile];
            [cell.contentView addSubview:address];
            time.frame = CGRectMake(10, address.bottom , SCREEN_WIDTH-20, 25);
            line.frame = CGRectMake(0, time.bottom, SCREEN_WIDTH, 10);
        }else{
            UIButton * addBtn = [PublicMethod addButton:CGRectMake(150, record.bottom, 100, 25) title:@"填写快递地址" backGround:nil setTag:indexPath.row +999 setId:self selector:@selector(address:) setFont:[UIFont systemFontOfSize:12] setTextColor:nil];
            addBtn.backgroundColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
            [addBtn setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
            [cell.contentView addSubview:addBtn];
            time.frame = CGRectMake(10, info.bottom , SCREEN_WIDTH-20, 25);
            line.frame = CGRectMake(0, time.bottom, SCREEN_WIDTH, 10);
        }
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    if (self.totalNum.length != 0) {
        headerView.text = [NSString stringWithFormat:@"  共摇中奖励%@次",self.totalNum];
    }else{
        headerView.text = [NSString stringWithFormat:@"  共摇中奖励0次"];
    }
    headerView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    headerView.font = [UIFont systemFontOfSize:15];
    headerView.font = [UIFont boldSystemFontOfSize:15];
    headerView.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    headerView.textAlignment = NSTextAlignmentLeft;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
    if (![[dict objectForKey:@"prize_type"] isEqualToString:@"3"]) {
        return 60;
    }else{
        if ([[dict objectForKey:@"name"]length] && [[dict objectForKey:@"mobile"]length] && [[dict objectForKey:@"address"]length]) {
            return 179;
        }else{
            return 85;
        }
    }
}
#pragma mark -RequestDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    if ([status isEqualToString:WEB_STATUS_3])
    {
        YHAppDelegate * delegate = (YHAppDelegate *)[UIApplication sharedApplication].delegate;
        [[YHAppDelegate appDelegate] changeCartNum:@"0"];
        [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
        [[UserAccount instance] logoutPassive];
        [delegate LoginPassive];
        return;
    }
    [self showNotice:errMsg];
    self.dataState = EGOOLoadFail;
    [self testFinishedLoadData];
    [self finishLoadTableViewData];
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_SHAKE_AWARD_LIST) {
        if (countPage > 1  ) {
            AwardListEntity * entity = (AwardListEntity *)netTransObj;
            if (entity.awardArray.count != 0) {
                for (NSDictionary * d in entity.awardArray) {
                    [self.dataArray addObject:d];
                }
            }
            [self._tableView setHidden:NO];
            if (requestStyle == Load_MoreStyle) {
                if (self.total == _dataArray.count) {
                    self.dataState = EGOOOther;
                }else{
                    self.dataState = EGOOHasMore;
                }
            }
            self.totalNum = [NSString stringWithFormat:@"%@", entity.total];
            self.total = _dataArray.count;
            [self._tableView reloadData];
            [self testFinishedLoadData];
        }else if (countPage == 1){
            AwardListEntity * entity = (AwardListEntity *)netTransObj;
            if ( ! self.dataArray){
                self.dataArray = [[NSMutableArray alloc]initWithArray:entity.awardArray];
            }else{
                self.dataArray = entity.awardArray;
            }
            self.totalNum = [NSString stringWithFormat:@"%@", entity.total];
            [self._tableView setHidden:NO];
            [self._tableView reloadData];
//            if ([_dataArray count] == 0) {
//                [self._tableView setHidden:YES];
//            }
            if (_dataArray.count <=20) {
                self.dataState = EGOOOther;
//                [self removeFooterView];
            }else{
                self.dataState = EGOOHasMore;
            }
        }
        [self._tableView reloadData];
        [self finishLoadTableViewData];
        
        CGFloat height = 0;
        NSArray *cellArray = [self._tableView visibleCells];
        for (UITableViewCell *visbleCell in cellArray) {
            height += visbleCell.height;
        }
        //移除上拉
        if (height < SCREEN_HEIGHT - 64-35) {
            [self removeFooterView];
        }else{
            [self testFinishedLoadData];
        }
    }
}
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
    _moreloading = YES;
    requestStyle = Load_RefrshStyle;
    countPage = 1;
    self.dataState = EGOOHasMore;
    [[NetTrans getInstance] shake_award_list:self page:@"1"];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    requestStyle = Load_MoreStyle;
    countPage ++;
    [[NetTrans getInstance] shake_award_list:self page:[NSString stringWithFormat:@"%ld",(long)countPage]];
    NSLog(@"getMore start requestInterface.");
}

@end
