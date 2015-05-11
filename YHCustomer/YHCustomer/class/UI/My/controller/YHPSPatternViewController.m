//
//  YHPSPatternViewController.m
//  YHCustomer
//
//  Created by dujinxin on 15-4-20.
//  Copyright (c) 2015年 富基融通. All rights reserved.
//

#import "YHPSPatternViewController.h"
#import "PSPatternEntity.h"

@interface YHPSPatternViewController()<UITableViewDataSource,UITableViewDelegate>{
//    UITableView * _tableView;
    UIButton * _leftView;
    UIButton * _rightView;
    UISegmentedControl * _driveSegment;
    
    NSMutableArray * _headArray;
    NSMutableArray * _cityArray;
    NSMutableArray * _countryArray;
    NSMutableArray * _streetArray;
    NSMutableArray * _supermarketArray;
    
    NSString * _country_id;
    NSString * _street_id;
    NSString * _superMarket_id;
    
    NSString * _country_name;
    NSString * _street_name;
    
    BOOL  _isPickUpSupermarket;
}

@end
@implementation YHPSPatternViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _headArray = [[NSMutableArray alloc]init ];
        _cityArray = [[NSMutableArray alloc]init ];
        _countryArray = [[NSMutableArray alloc]init ];
        _streetArray = [[NSMutableArray alloc]init ];
        _supermarketArray = [[NSMutableArray alloc]init ];
        _isPickUpSupermarket = NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //UI init
    self.navigationItem.title = @"选择配送方式";
    self.navigationItem.leftBarButtonItems = BACKBARBUTTON(@"返回", @selector(backEvent:));
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithTableView];
    [self initWithSubviewsForUITableViewCell];
    //data init
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"region_id"] isEqualToString:[self.regionDic objectForKey:@"region_id"]] && [[[NSUserDefaults standardUserDefaults ] objectForKey:@"psStyle"] integerValue] == 1) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"country_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"]) {
            _country_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"country_id"];
            _country_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"]) {
            _street_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"];
            _street_name = [[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"];
        }
    }
    //network request
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        [[PSNetTrans getInstance]API_RegionCityPattern:self region_id:[self.regionDic objectForKey:@"region_id"]];
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//        [[PSNetTrans getInstance]API_RegionCountry_StreetList:self p_id:[self.regionDic objectForKey:@"region_id"]];
//    });
    [[PSNetTrans getInstance]API_RegionCityPattern:self region_id:[self.regionDic objectForKey:@"region_id"]];
    
    
}
#pragma mark - InitView
-(void)initWithTableView{
    self._tableView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64);
//    self._tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
    self._tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.view addSubview:self._tableView];
}
-(void)initWithSubviewsForUITableViewCell{
    
    _leftView = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftView.frame = CGRectMake(30, 25, 115, 35);
    _leftView.layer.cornerRadius = 2.0f;
    _leftView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
    [_leftView setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
    _leftView.selected = YES;
    [_leftView addTarget:self action:@selector(changePattern:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightView.frame = CGRectMake(_leftView.right +30, 25, 115, 35);
    _rightView.layer.cornerRadius = 2.0f;
    _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0];
    [_leftView setTitleColor:[PublicMethod colorWithHexValue:0xffffff alpha:1.0] forState:UIControlStateNormal];
    [_rightView addTarget:self action:@selector(changePattern:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray * array = [NSMutableArray array];
    if ([[self.regionDic objectForKey:@"region_name"] isEqualToString:[UserAccount instance].location_CityName] && [[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"] && [[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"]) {
        [array addObject:[self.regionDic objectForKey:@"region_name"]];
        [array addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"country_name"]];
        [array addObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"street_name"]];
    }else{
        [array addObject:[self.regionDic objectForKey:@"region_name"]];
        [array addObject:@"选择区"];
        [array addObject:@"选择街道"];
    }
    _driveSegment = [[UISegmentedControl alloc]initWithItems:array];
    _driveSegment.frame = CGRectMake(25, _leftView.bottom +25, SCREEN_WIDTH -50, 30);
    _driveSegment.selectedSegmentIndex = 1;
    _driveSegment.hidden = YES;
    [_driveSegment addTarget:self action:@selector(selectDrive:) forControlEvents:UIControlEventValueChanged];
    [_driveSegment setEnabled:NO forSegmentAtIndex:0];
    [_driveSegment setTintColor:[PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0]];
    
    NSDictionary * unableAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12],NSForegroundColorAttributeName:[PublicMethod colorWithHexValue:0xc6c2c1 alpha:1.0]};
    NSDictionary * selectedAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12],NSForegroundColorAttributeName:[PublicMethod colorWithHexValue:0x252525 alpha:1.0]};
    NSDictionary * unselectedAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12],NSForegroundColorAttributeName:[PublicMethod colorWithHexValue:0x4c4c4c alpha:1.0]};
    [_driveSegment setTitleTextAttributes:unableAttributes forState:UIControlStateDisabled];
    [_driveSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [_driveSegment setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
    
    
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!_isPickUpSupermarket) {
            return 135;
        }else{
            return 85;
        }
    }else{
        if (_isPickUpSupermarket) {
            return 60;
        }else{
            return 35;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (_isPickUpSupermarket) {
            //保存自提信息
            [[NSUserDefaults standardUserDefaults] setObject:[[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"bu_code"] forKey:@"bu_code"];
            [[NSUserDefaults standardUserDefaults] setObject:[[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"id"] forKey:@"bu_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"bu_name"] forKey:@"bu_name"];
            [[NSUserDefaults standardUserDefaults] setObject:[[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"address"] forKey:@"bu_address"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_id"] forKey:@"region_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_name"] forKey:@"region_name"];
            [[NSUserDefaults standardUserDefaults] setObject:[[_headArray objectAtIndex:1] objectForKey:@"type"] forKey:@"psStyle"];
            //清除配送信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"country_name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street_name"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self restoreCityReloadData:self.regionDic];
            [self popViewControllerAndSelectTabOne];
        }else{
            if (_driveSegment.selectedSegmentIndex == 0) {
                
            } else if (_driveSegment.selectedSegmentIndex == 1){
                _driveSegment.selectedSegmentIndex = 2;
                _country_id = [[_countryArray objectAtIndex:indexPath.row -1] objectForKey:@"id"];
                _country_name = [[_countryArray objectAtIndex:indexPath.row -1] objectForKey:@"name"];
                [_driveSegment setTitle:_country_name forSegmentAtIndex:1];
                [_driveSegment setTitle:@"选择街道" forSegmentAtIndex:2];
                [[PSNetTrans getInstance] API_RegionCountry_StreetList:self p_id:_country_id];
            } else{
                _street_id = [[_streetArray objectAtIndex:indexPath.row -1] objectForKey:@"id"];
                _street_name = [[_streetArray objectAtIndex:indexPath.row -1] objectForKey:@"name"];
                [[PSNetTrans getInstance] API_RegionStreet_SupermarketList:self region_id:[self.regionDic objectForKey:@"region_id"] street_id:_street_id];
            }
        }
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isPickUpSupermarket) {
        return _supermarketArray.count + 1;
    }else{
        if (_driveSegment.selectedSegmentIndex == 0) {
            return _cityArray.count +1;
        }else if (_driveSegment.selectedSegmentIndex == 1){
            return _countryArray.count +1;
        }else {
            return _streetArray.count +1;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:12];

    }
    [cell.contentView removeAllSubviews];
    cell.textLabel.text = nil;
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_headArray.count !=0) {
            [cell.contentView addSubview:_leftView];
            [cell.contentView addSubview:_rightView];
            [cell.contentView addSubview:_driveSegment];
            
            if (_isPickUpSupermarket) {
                _driveSegment.hidden = YES;
                _leftView.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0];
                _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
            }else{
                _driveSegment.hidden = NO;
                _leftView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
                _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0];
            }
        }
    }else{
        UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 7.5, 20, 20)];
        arrow.backgroundColor = [UIColor clearColor];
        arrow.tag = 102;
        [cell.contentView addSubview:arrow];
        

        if (_isPickUpSupermarket) {
            if (_supermarketArray.count != 0) {
                arrow.frame = CGRectMake(SCREEN_WIDTH - 40, 20, 20, 20);
                
                UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH -20, 20)];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.textColor = [PublicMethod colorWithHexValue:0x252525 alpha:1.0];
                titleLabel.tag = 103;
                titleLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLabel];
                
                UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom , SCREEN_WIDTH -20, 20)];
                addressLabel.backgroundColor = [UIColor clearColor];
                addressLabel.textColor = [PublicMethod colorWithHexValue:0x7d7d7d alpha:1.0];
                addressLabel.tag = 104;
                addressLabel.numberOfLines = 2;
                addressLabel.font = [UIFont systemFontOfSize:12];
                [cell.contentView addSubview:addressLabel];
                
                titleLabel.text = [[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"bu_name"];
                addressLabel.text = [[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"address"];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"bu_code"]integerValue] == [[[_supermarketArray objectAtIndex:indexPath.row -1] objectForKey:@"bu_code"]integerValue] && [[[NSUserDefaults standardUserDefaults ] objectForKey:@"psStyle"]integerValue] == 2) {
                    arrow.image = [UIImage imageNamed:@"ps_selected"];
                }
            }
        }else{
            arrow.frame = CGRectMake(SCREEN_WIDTH - 40, 7.5, 20, 20);
            if (_driveSegment.selectedSegmentIndex == 0) {
                
            }else if (_driveSegment.selectedSegmentIndex == 1){
                if (_countryArray.count !=0) {
                    cell.textLabel.text = [[_countryArray objectAtIndex:indexPath.row -1] objectForKey:@"name"];
                    if ([_country_id isEqualToString:[[_countryArray objectAtIndex:indexPath.row -1] objectForKey:@"id"]]) {
                        arrow.image = [UIImage imageNamed:@"ps_selected"];
                        [_driveSegment setTitle:[[_countryArray objectAtIndex:indexPath.row -1] objectForKey:@"name"] forSegmentAtIndex:1];
                    }
                }
            }else{
                if (_streetArray.count !=0) {
                    cell.textLabel.text = [[_streetArray objectAtIndex:indexPath.row -1] objectForKey:@"name"];
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"street_id"] isEqualToString:[[_streetArray objectAtIndex:indexPath.row -1] objectForKey:@"id"]]) {
                        arrow.image = [UIImage imageNamed:@"ps_selected"];
                        [_driveSegment setTitle:[[_streetArray objectAtIndex:indexPath.row -1] objectForKey:@"name"] forSegmentAtIndex:2];
                    }
                }
            }

        }
    }
//    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0,[self tableView:_tableView heightForRowAtIndexPath:indexPath] -1, SCREEN_WIDTH, 1)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [cell addSubview:line];
    
    return cell;
}
#pragma mark - ControlEvents
-(void)backEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changePattern:(UIButton *)btn{
    
    if (btn == _leftView) {
        if ([[[_headArray objectAtIndex:0] objectForKey:@"is_usable"] integerValue] == 0) {
            [self showAlert:@"该城市暂不支持配送，敬请期待"];
            return;
        }
        _leftView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
        _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0];
        
        [self.refreshHeaderView removeFromSuperview];
        self.refreshHeaderView = nil;
        
        _isPickUpSupermarket = NO;
        [self._tableView reloadData];
        
    }else{
        if ([[[_headArray objectAtIndex:1] objectForKey:@"is_usable"] integerValue] == 0) {
            [self showAlert:@"该城市暂不支持自提，敬请期待"];
            return;
        }
        _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
        _leftView.backgroundColor = [PublicMethod colorWithHexValue:0xd7d7d7 alpha:1.0];
        [self addRefreshTableHeaderView];
        _isPickUpSupermarket = YES;
        if (_supermarketArray.count == 0) {
            [[PSNetTrans getInstance]API_RegionPickUpSuperMarketList:self region_id:[self.regionDic objectForKey:@"region_id"] page:@"1" limit:@"10"];
        }else{
            [self._tableView reloadData];
        }
    }
    
}
-(void)selectDrive:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        //不可选
    } else if (segment.selectedSegmentIndex ==1){
        _driveSegment.selectedSegmentIndex = 1;
        [self._tableView reloadData];
    } else{
        if (_country_id && _country_id.length != 0) {
            _driveSegment.selectedSegmentIndex = 2;
            if (_streetArray.count == 0) {
                [[PSNetTrans getInstance]API_RegionCountry_StreetList:self p_id:_country_id];
            }else{
                [self._tableView reloadData];
            }
        }else{
            _driveSegment.selectedSegmentIndex = 1;
            [self showAlert:@"请先选择区县！"];
        }
    }
}
#pragma mark ----------------------------------------YHBaseViewController method
/*刷新接口请求*/
- (void)reloadTableViewDataSource{
    
    _moreloading = YES;
    countPage = 1;
    requestStyle = Load_RefrshStyle;
    self.dataState = EGOOHasMore;
    [[PSNetTrans getInstance]API_RegionPickUpSuperMarketList:self region_id:[self.regionDic objectForKey:@"region_id"] page:[NSString stringWithFormat:@"%d",countPage] limit:@"10"];
    NSLog(@"refresh start requestInterface.");
}

/*加载更多接口请求*/
- (void)loadMoreTableViewDataSource{
    _reloading = YES;
    countPage ++;
    requestStyle = Load_MoreStyle;
    [[PSNetTrans getInstance]API_RegionPickUpSuperMarketList:self region_id:[self.regionDic objectForKey:@"region_id"] page:[NSString stringWithFormat:@"%d",countPage] limit:@"10"];
    
    NSLog(@"getMore start requestInterface.");
}
#pragma mark - NetworkDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    [self showNotice:errMsg];
    if (nTag == t_API_PS_COUNTRY_STREET_LIST){
        if (_driveSegment.selectedSegmentIndex == 1) {
            _driveSegment.selectedSegmentIndex = 1;
        }else if (_driveSegment.selectedSegmentIndex == 2){
            _driveSegment.selectedSegmentIndex = 1;
            _country_id = nil;
        }
    }
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag{
    if (nTag == t_API_PS_REGION_PATTERN) {
        _headArray = (NSMutableArray *)netTransObj;
        
        [_leftView setTitle:[[_headArray objectAtIndex:0] objectForKey:@"type_name"] forState:UIControlStateNormal];
        [_rightView setTitle:[[_headArray objectAtIndex:1] objectForKey:@"type_name"] forState:UIControlStateNormal];
        //配送可用
        if ([[[_headArray objectAtIndex:0] objectForKey:@"is_usable"]integerValue] == 1 && [[[_headArray objectAtIndex:0] objectForKey:@"type"] integerValue] == 1) {
            
            [self.refreshHeaderView removeFromSuperview];
            self.refreshHeaderView = nil;
            
            _isPickUpSupermarket = NO;
            [[PSNetTrans getInstance]API_RegionCountry_StreetList:self p_id:[self.regionDic objectForKey:@"region_id"]];
        }else{
            //配送不可用
            if ([[[_headArray objectAtIndex:1] objectForKey:@"is_usable"] integerValue] == 1
                && [[[_headArray objectAtIndex:1] objectForKey:@"type"] integerValue] == 2) {
                
                [self addRefreshTableHeaderView];
                _isPickUpSupermarket = YES;
                //            _leftView.enabled = NO;
                _rightView.backgroundColor = [PublicMethod colorWithHexValue:0xe40011 alpha:1.0];
                [[PSNetTrans getInstance]API_RegionPickUpSuperMarketList:self region_id:[self.regionDic objectForKey:@"region_id"] page:@"1" limit:@"10"];
            }
        }
        
    }else if (nTag == t_API_PS_COUNTRY_STREET_LIST){
        if (_driveSegment.selectedSegmentIndex == 1) {
            _driveSegment.selectedSegmentIndex = 1;
            _countryArray = (NSMutableArray *)netTransObj;
            [self._tableView reloadData];
        }else if (_driveSegment.selectedSegmentIndex == 2){
            _driveSegment.selectedSegmentIndex = 2;
            _streetArray = (NSMutableArray *)netTransObj;
            [self._tableView reloadData];
        }
    }else if (nTag == t_API_PS_STREET_SUPERMARKET_LIST){
        NSMutableArray * array = [[NSMutableArray alloc]initWithArray:(NSMutableArray *)netTransObj];
        
        //保存配送信息
        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_id"] forKey:@"region_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.regionDic objectForKey:@"region_name"] forKey:@"region_name"];
        [[NSUserDefaults standardUserDefaults] setObject:_country_id forKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] setObject:_street_id forKey:@"street_id"];
        [[NSUserDefaults standardUserDefaults] setObject:_country_name forKey:@"country_name"];
        [[NSUserDefaults standardUserDefaults] setObject:_street_name forKey:@"street_name"];
        [[NSUserDefaults standardUserDefaults] setObject:[[array lastObject] objectForKey:@"bu_code"] forKey:@"bu_code"];
        [[NSUserDefaults standardUserDefaults] setObject:[[array lastObject] objectForKey:@"type"] forKey:@"bu_type"];//实体店，虚拟店
        [[NSUserDefaults standardUserDefaults] setObject:[[_headArray objectAtIndex:0] objectForKey:@"type"] forKey:@"psStyle"];
        //清除自提信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bu_address"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self restoreCityReloadData:self.regionDic];
        [self popViewControllerAndSelectTabOne];
    }else if (nTag == t_API_PU_SUPERMARKET_LIST){
        if (requestStyle != Load_MoreStyle) {
            if (requestStyle == Load_RefrshStyle) {
                _supermarketArray = nil;
            }
            _supermarketArray = (NSMutableArray *)netTransObj;
            self.total = _supermarketArray.count;
        }else{
            [_supermarketArray addObjectsFromArray:(NSMutableArray *)netTransObj];
            if (self.total + 10 > _supermarketArray.count) {
                self.dataState = EGOOOther;
            }else{
                self.dataState = EGOOHasMore;
            }
        }
        
        _isPickUpSupermarket = YES;
        if (_supermarketArray.count * 60 + 85 + 64 < SCREEN_HEIGHT) {
            [self removeFooterView];
        }else{
            if (self.total <10) {
                [self removeFooterView];
            }else{
                self.dataState = EGOOHasMore;
                [self testFinishedLoadData];
            }
        }
        self.total = _supermarketArray.count;
        [self._tableView reloadData];
    }
    [self finishLoadTableViewData];
}


// section-cell Select
- (void)restoreCityReloadData:(NSDictionary *)locationDic1{
    if (nil != locationDic1)
    {
        if (![[UserAccount instance].region_id isEqualToString:[locationDic1 objectForKey:@"region_id"]]) {//切换城市，清空门店
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"storeInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (![[locationDic1 objectForKey:@"region_id"] isKindOfClass:[NSNull class]])
            {
                [UserAccount instance].region_id = [locationDic1 objectForKey:@"region_id"];
                [UserAccount instance].location_CityName = [locationDic1 objectForKey:@"region_name"];
                [[UserAccount instance] saveAccount];
            }
            //切换城市
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];

        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCity" object:nil];
        }
        
    }

}

- (void)popViewControllerAndSelectTabOne
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[YHAppDelegate appDelegate].mytabBarController setSelectedIndex:0];
}
@end
