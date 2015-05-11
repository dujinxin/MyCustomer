//
//  YHSearchSelectViewController.m
//  YHCustomer
//
//  Created by dujinxin on 14-9-19.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHSearchSelectViewController.h"
#import "BrandEntity.h"
#import "YHScreenViewCell.h"

typedef enum {
    kHotScreenTag = 100 ,
    
}kButtonTag;

@interface YHSearchSelectViewController ()
{
    NSMutableArray * _dataArray;
    NSMutableArray * _hotArray;
    NSMutableArray * _sectionTitleArray;
}
@end

@implementation YHSearchSelectViewController

@synthesize selectName = _selectName;
@synthesize string = _string;
@synthesize table  = _table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    self.navigationController.navigationBarHidden = YES;
    
//    [self.table reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initData];
    
    [self addNavigationView];
    if (IOS_VERSION >=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initData{
    _selectName = [NSString string];
//    _string = [NSString string];
    _dataArray = [[NSMutableArray alloc]init];
    
    _hotArray = [[NSMutableArray alloc]init ];
    
    _sectionTitleArray = [[NSMutableArray alloc] init];
}
- (void)addNavigationView
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIImageView * navigationBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    navigationBar.backgroundColor = [UIColor blackColor];
    navigationBar.userInteractionEnabled = YES;
    [self.view addSubview:navigationBar];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 27, SCREEN_WIDTH-88, 30)];
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.text = @"品牌筛选";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    
    [navigationBar addSubview:titleLabel];
    
    //左边item
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(7, 27, 30, 30);
    //    leftBtn.tag = kLeftButtonTag;
    [leftBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [navigationBar addSubview:leftBtn];
    
}
- (void)itemClick:(UIButton *)btn{
    //    self.selectName = [NSString stringWithString: btn.currentTitle];
    if (self.selectScreenGoods) {
        self.selectScreenGoods(self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_hotArray.count) {
        if (_dataArray.count) {
            return _dataArray.count + 1;
        }else{
            return 1;
        }
    }else{
        if (_dataArray.count) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//- (NSString * )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString * title = [_sectionTitleArray objectAtIndex:section];
//    return title;
//    
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.font = [UIFont systemFontOfSize:15];
    headerView.text = [NSString stringWithFormat:@"  %@", [ _sectionTitleArray objectAtIndex:section]];
    headerView.textColor = [PublicMethod colorWithHexValue:0xfc5856 alpha:1.0];
    headerView.textAlignment = NSTextAlignmentLeft;
    headerView.backgroundColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0];
    return headerView;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * indexTitles = [NSMutableArray array];
    if (_sectionTitleArray.count >0) {
        indexTitles =[NSMutableArray arrayWithArray:_sectionTitleArray];
        if ([[indexTitles objectAtIndex:0]isEqualToString:@"热门品牌"]) {
            [indexTitles replaceObjectAtIndex:0 withObject:@"热门"];
        }else{
            //没有热门品牌
        }
    }
    return indexTitles;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hotArray.count) {
        if (_dataArray.count) {
            if (section == 0) {
                return 1;
            }else{
                return [[_dataArray objectAtIndex:section -1]count];
            }
        }else{
            return 1;
        }
    }else{
        if (_dataArray.count) {
            return [[_dataArray objectAtIndex:section]count];
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hotArray.count) {
        if (_dataArray.count) {
            if (indexPath.section == 0) {
                NSString * cellIdentifier = @"oneCell";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    for (int i = 0; i < [_hotArray count]; i ++ ) {
                        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(10 + (i %3) * 92 , 10 + (i /3) *48, 82, 38);
                        btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                        BrandEntity * entity = [_hotArray objectAtIndex:i];
                        [btn setTitle:entity.brand_name forState:UIControlStateNormal];
                        [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
                        btn.titleLabel.font = [UIFont systemFontOfSize:15];
                        btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
                        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        btn.titleLabel.numberOfLines = 1;
                        btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                        btn.layer.borderWidth = 0.5f;
                        btn.tag = kHotScreenTag + i;
                        [btn addTarget:self action:@selector(hotScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:btn];
                    }
                }
                return cell;
            }else {
                NSString * cellIdentifier = @"Cell";
                YHScreenViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[YHScreenViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                BrandEntity * entity = [[_dataArray objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
                cell.textLabel.text = entity.brand_name;
                //选中全部
                if (entity.isSelected == YES) {
                    cell.arrow.image = [UIImage imageNamed:@"tab_sel"];
                    //                    [cell setSelected:YES];
                }else{
                    cell.arrow.image = nil;
                }
                return cell;
            }
            
        }else{
            NSString * cellIdentifier = @"Cell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                for (int i = 0; i < [_hotArray count]; i ++ ) {
                    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(10 + (i %3) * 92 , 10 + (i /3) *48, 82, 38);
                    btn.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
                    BrandEntity * entity = [_hotArray objectAtIndex:i];
                    [btn setTitle:entity.brand_name forState:UIControlStateNormal];
                    [btn setTitleColor:[PublicMethod colorWithHexValue:0x333333 alpha:1.0] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                    btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    btn.titleLabel.numberOfLines = 1;
                    btn.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
                    btn.layer.borderWidth = 0.5f;
                    btn.tag = kHotScreenTag + i;
                    [btn addTarget:self action:@selector(hotScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                }
            }
            return cell;
        }
    }else{
        if (_dataArray.count) {
            NSString * cellIdentifier = @"Cell";
            YHScreenViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[YHScreenViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            BrandEntity * entity = [[_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.textLabel.text = entity.brand_name;
            //选中全部
            if (entity.isSelected) {
                cell.arrow.image = [UIImage imageNamed:@"tab_sel"];
                //                [cell setSelected:YES];
            }else{
                cell.arrow.image = nil;
            }
            return cell;
        }else{
            return nil;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hotArray.count) {
        if (_dataArray.count) {
            if (indexPath.section == 0 ) {
                if (_hotArray.count % 3 == 0) {
                    return (_hotArray.count /3) * 48 +10;
                }else{
                    return (_hotArray.count /3 +1) * 48 +10;
                }
            }else{
                return 40;
            }
        }else{
            return (_hotArray.count /3 +1) * 48 +10;
        }
    }else{
        if (_dataArray.count) {
            return 40;
        }else{
            return 0;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hotArray.count) {
        if (_dataArray.count) {
            if (indexPath.section == 0 ) {
                //不可选
            }else{
                if (indexPath.section == 1) {
                    //全部
                    self.selectName = @"";
                }else{

                    BrandEntity * selectEntity = [[_dataArray objectAtIndex:indexPath.section -1]objectAtIndex:indexPath.row];
                    self.selectName = selectEntity.brand_name;

                    for (NSArray * array in _dataArray) {
                        for (BrandEntity * entity in array) {
                            if ([selectEntity.brand_name isEqualToString:entity.brand_name]) {
                                entity.isSelected = YES;
                            }else{
                                entity.isSelected = NO;
                            }
                        }
                    }
                }
                [self.table reloadData];
            }
        }else{
            //不可选
        }
    }else{
        if (_dataArray.count) {
            if (indexPath.section == 0) {
                //全部
                self.selectName = @"";
            }else{

                BrandEntity * selectEntity = [[_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                self.selectName = selectEntity.brand_name;
                for (NSArray * array in _dataArray) {
                    for (BrandEntity * entity in array) {
                        if ([selectEntity.brand_name isEqualToString:entity.brand_name]) {
                            entity.isSelected = YES;
                        }else{
                            entity.isSelected = NO;
                        }
                    }
                }
            }
            [self.table reloadData];
        }else{
            //
        }
    }
    if (self.selectScreenGoods) {
        self.selectScreenGoods(self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BtnClickEvents
- (void)hotScreenBtnClick:(UIButton *)btn{
    self.selectName = [NSString stringWithString: btn.currentTitle];
    if (self.selectScreenGoods) {
        self.selectScreenGoods(self);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ApiRequestDelegate
-(void)setRequstParams:(NSMutableDictionary *)param {
    //    bu_category_id_default = [param objectForKey:@"bu_category_id"];
    //    params = [NSMutableDictionary dictionary];
    //    params = param;
    //    [params setValue:@"0" forKey:@"is_stock"];
    
    [[PSNetTrans getInstance] get_Key_Brand_Screen_list:self category_code:[param valueForKey:@"category_code"] key:[param objectForKey:@"key"] is_parent_category:[[param objectForKey:@"is_parent_category"]integerValue]];
    
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    if(t_API_KEY_BRAND_SCREEN_LIST == nTag)
    {
        NSDictionary *dict = (NSDictionary *)netTransObj;
        //热门品牌数组
        if ([dict objectForKey:@"hot_brand_list"]) {
            [_hotArray addObjectsFromArray:[dict objectForKey:@"hot_brand_list"]];
            
        }
        //品牌数组
        NSMutableArray * wordArray = [[NSMutableArray alloc]init];
        if ([dict objectForKey:@"brand_list"]) {
            NSArray * array = [dict objectForKey:@"brand_list"];
            for (char i = '#'; i <= 'Z'; i ++) {
                NSMutableArray * arr = [[NSMutableArray alloc]init];
                for (BrandEntity * entity in array) {
                    if ([entity.brand_name isEqualToString:self.string]) {
                        entity.isSelected = YES;
                    }
                    if ([entity.letter isEqualToString:[NSString stringWithFormat:@"%c",i]]) {
                        [arr addObject:entity];
                    }
                }
                if (arr.count != 0) {
                    [wordArray addObject:[NSString stringWithFormat:@"%c",i]];
                    [_dataArray addObject:arr];
                }
            }
        }
        
        if (_dataArray.count) {
            NSMutableArray * arr = [[NSMutableArray alloc]init ];
            BrandEntity * entity = [[BrandEntity alloc]init];
            entity.brand_name = @"全部品牌";
            if (self.string.length == 0 || self.string == nil ) {
                entity.isSelected = YES;
            }
            [arr addObject:entity];
            [_dataArray insertObject:arr atIndex:0];
        }
        //分区标题数组
        if (_hotArray.count) {
            if (_dataArray.count) {
                [_sectionTitleArray addObject:@"热门品牌"];
                [_sectionTitleArray addObject:@"全部"];
                for (int i = 0 ; i < wordArray.count; i ++ ) {
                    [_sectionTitleArray addObject:[wordArray objectAtIndex:i]];
                }
            }else{
                [_sectionTitleArray addObject:@"热门品牌"];;
            }
        }else{
            if (_dataArray.count) {
                [_sectionTitleArray addObject:@"全部"];
                for (int i = 0 ; i < wordArray.count; i ++ ) {
                    [_sectionTitleArray addObject:[wordArray objectAtIndex:i]];
                }
            }else{
                //空
            }
        }
        
        [self.table reloadData];
    }
    
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [[iToast makeText:errMsg]show];
}


@end

