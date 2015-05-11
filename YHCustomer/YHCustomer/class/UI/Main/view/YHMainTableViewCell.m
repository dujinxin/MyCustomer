//
//  YHMainTableViewCell.m
//  YHCustomer
//
//  Created by kongbo on 13-12-18.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHMainTableViewCell.h"
#import "GoodsEntity.h"
#import "YHGoodsDetailViewController.h"
#import "YHCommentViewController.H"
#import "CategoryEntity.h"
#import "YHPromotionViewController.h"
#import "YHWebGoodListViewController.h"
#import "YHGoodsTabViewController.h"
#import "YHSearchResultsViewController.h"
#import "YHFixedToSnapUpViewController.h"
#import "YHFlexibleToSnapUpViewController.h"
@implementation YHMainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xf5f5f5 alpha:1.0];
        [self initView];
    }
    return self;
}

-(void)initView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
    bgView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:bgView];
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10+161, 144)];
    leftView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:leftView];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 130, 120)];
    image.userInteractionEnabled = YES;
    image.backgroundColor = [UIColor yellowColor];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    [image addGestureRecognizer:gestureRecognizer];
    [leftView addSubview:image];
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(10+130, 0, 10+161+10, 144)];
    rightView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:rightView];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"main_theme_bg"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"main_theme_bg"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, 10, 161, 38);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [rightView addSubview:btn];
    
    tab1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab1.tag = 0;
    [tab1 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab1 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab1 setBackgroundColor:[UIColor whiteColor]];
    [tab1 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab1.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab1.frame = CGRectMake(10+0*(47+10), btn.bottom + 10, 47, 31);
    [tab1 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab1];
    
    tab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab2.tag = 1;
    [tab2 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab2 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab2 setBackgroundColor:[UIColor whiteColor]];
    [tab2 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab2.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab2.frame = CGRectMake(10+1*(47+10), btn.bottom + 10, 47, 31);
    [tab2 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab2];
    
    tab3 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab3.tag = 2;
    [tab3 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab3 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab3 setBackgroundColor:[UIColor whiteColor]];
    [tab3 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab3.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab3.frame = CGRectMake(10+2*(47+10), btn.bottom + 10, 47, 31);
    [tab3 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab3];
    
    tab4 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab4.tag = 3;
    [tab4 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab4 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab4 setBackgroundColor:[UIColor whiteColor]];
    [tab4 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab4.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab4.frame = CGRectMake(10+0*(47+10), tab3.bottom + 10, 47, 31);
    [tab4 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab4];
    
    tab5 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab5.tag = 4;
    [tab5 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab5 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab5 setBackgroundColor:[UIColor whiteColor]];
    [tab5 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab5.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab5.frame = CGRectMake(10+1*(47+10), tab3.bottom + 10, 47, 31);
    [tab5 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab5];
    
    tab6 = [UIButton buttonWithType:UIButtonTypeCustom];
    tab6.tag = 5;
    [tab6 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn"] forState:UIControlStateNormal];
    [tab6 setBackgroundImage:[UIImage imageNamed:@"main_tab_btn_selected"] forState:UIControlStateHighlighted];
    [tab6 setBackgroundColor:[UIColor whiteColor]];
    [tab6 setTitleColor:[PublicMethod colorWithHexValue:0x646464 alpha:1.0] forState:UIControlStateNormal];
    tab6.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    tab6.frame = CGRectMake(10+2*(47+10), tab3.bottom + 10, 47, 31);
    [tab6 addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tab6];
}

-(void)setCellView:(CategoryEntity *)entity
{
    categoryEntity = entity;
    [image setImageWithURL:[NSURL URLWithString:entity.image.image_url] placeholderImage:[UIImage imageNamed:@"goods_default"]];
    [btn setTitle:entity.title.title forState:UIControlStateNormal];
    
    ActivityEntity *tab1Entity = (ActivityEntity *)[entity.tabs objectAtIndex:0];
    [tab1 setTitle:tab1Entity.title forState:UIControlStateNormal];
    
    ActivityEntity *tab2Entity = (ActivityEntity *)[entity.tabs objectAtIndex:1];
    [tab2 setTitle:tab2Entity.title forState:UIControlStateNormal];
    
    ActivityEntity *tab3Entity = (ActivityEntity *)[entity.tabs objectAtIndex:2];
    [tab3 setTitle:tab3Entity.title forState:UIControlStateNormal];
    
    ActivityEntity *tab4Entity = (ActivityEntity *)[entity.tabs objectAtIndex:3];
    [tab4 setTitle:tab4Entity.title forState:UIControlStateNormal];
    
    ActivityEntity *tab5Entity = (ActivityEntity *)[entity.tabs objectAtIndex:4];
    [tab5 setTitle:tab5Entity.title forState:UIControlStateNormal];
    
    ActivityEntity *tab6Entity = (ActivityEntity *)[entity.tabs objectAtIndex:5];
    [tab6 setTitle:tab6Entity.title forState:UIControlStateNormal];
    if (self.rowNum%2 == 0) {
        leftView.frame = CGRectMake(161+10, 0, 10+161, 144);
    } else {
        leftView.frame = CGRectMake(0, 0, 10+161, 144);
    }

    if (self.rowNum%2 == 0) {
        rightView.frame = CGRectMake(0, 0, 10+161+10, 144);
    } else {
        rightView.frame = CGRectMake(10+130, 0, 10+161+10, 144);
    }
}

- (void)imageAction:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID25 props:nil];
    
    NSString *jump_type = categoryEntity.image.jump_type;
    if (![jump_type isEqualToString:@"6"]) {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    }
    switch ([jump_type integerValue]) {
        case 1://品类
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.image.title;
            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"category" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_category_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
////            if ([params count]>1) {
////                proVC.navigationItem.title = [params objectAtIndex:1];
////            }
//            proVC.navigationItem.title = categoryEntity.image.title;
//            [proVC setParamerWihtType:@"5" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 2://品牌
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.image.title;
            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"brand" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_brand_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
////            if ([params count]>1) {
////                proVC.navigationItem.title = [params objectAtIndex:1];
////            }
//            proVC.navigationItem.title = categoryEntity.image.title;
//            [proVC setParamerWihtType:@"4" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 3://主题标签
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.image.title;
            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"tag" forKey:@"type"];
            [dic setValue:@"0" forKey:@"bu_id"];
            [dic setValue:[params objectAtIndex:0] forKey:@"tag_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
////            if ([params count]>1) {
////                proVC.navigationItem.title = [params objectAtIndex:1];
////            }
//            proVC.navigationItem.title = categoryEntity.image.title;
//            [proVC setParamerWihtType:@"7" Id:@"" tag:[[params objectAtIndex:0] integerValue]];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 4://搜索
        {
            
            YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
            srvc.view.backgroundColor = [UIColor clearColor];
            srvc.navigationItem.title = categoryEntity.image.jump_parametric;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:categoryEntity.image.jump_parametric forKey:@"key"];
            [params setValue:@"0" forKey:@"bu_id"];
            [params setValue:@"default" forKey:@"order"];
            [params setValue:@"search" forKey:@"type"];
            [params setValue:jump_type forKey:@"jump_type"];
            [srvc setRequstParams:params];
            [self.mainVC.navigationController pushViewController:srvc animated:YES];

        }
            break;
        case 5://商品详情
        {
            YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,categoryEntity.image.jump_parametric,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            [detailVC setMainGoodsUrl:url goodsID:categoryEntity.image.jump_parametric];
            [self.mainVC.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 6://dm商品列表或瀑布流
        {
            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
            [[PSNetTrans getInstance]get_DM_Info:self.mainVC DMId:[params objectAtIndex:0]];
        }
            break;
        case 7://固定抢购
        {
            YHFixedToSnapUpViewController *vc = [[YHFixedToSnapUpViewController alloc] init];
            vc.Forward = YES;
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8://灵活抢购
        {
            YHFlexibleToSnapUpViewController *vc = [[YHFlexibleToSnapUpViewController alloc] init];
            NSArray *params = [categoryEntity.image.jump_parametric componentsSeparatedByString:@":"];
            vc.activity_id = [params objectAtIndex:0];
            
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)tabAction:(id)sender{
    [MTA trackCustomKeyValueEvent:EVENT_ID25 props:nil];
    
    UIButton *btnClick = (UIButton *)sender;
    ActivityEntity *entity = (ActivityEntity *)[categoryEntity.tabs objectAtIndex:btnClick.tag];
    NSString *jump_type = entity.jump_type;
    if (![jump_type isEqualToString:@"6"]) {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    }
    switch ([jump_type integerValue]) {
        case 1://品类
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = entity.title;
            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"category" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_category_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = entity.title;
//            [proVC setParamerWihtType:@"5" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 2://品牌
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = entity.title;
            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"brand" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_brand_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = entity.title;
//            [proVC setParamerWihtType:@"4" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 3://主题标签
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = entity.title;
            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"tag" forKey:@"type"];
            [dic setValue:@"0" forKey:@"bu_id"];
            [dic setValue:[params objectAtIndex:0] forKey:@"tag_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = entity.title;
//            [proVC setParamerWihtType:@"7" Id:@"" tag:[[params objectAtIndex:0] integerValue]];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 4://搜索
        {
            YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
            srvc.view.backgroundColor = [UIColor clearColor];
            srvc.navigationItem.title = categoryEntity.image.jump_parametric;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:categoryEntity.image.jump_parametric forKey:@"key"];
            [params setValue:@"0" forKey:@"bu_id"];
            [params setValue:@"default" forKey:@"order"];
            [params setValue:@"search" forKey:@"type"];
            [params setValue:jump_type forKey:@"jump_type"];
            [srvc setRequstParams:params];
            [self.mainVC.navigationController pushViewController:srvc animated:YES];
           
            
//            YHWebGoodListViewController *searchResult = [[YHWebGoodListViewController alloc] init];
//            [searchResult setParamerWihtType:@"6" Id:entity.jump_parametric];
//            [self.mainVC.navigationController pushViewController:searchResult animated:YES];
        }
            break;
        case 5://商品详情
        {
            YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,entity.jump_parametric,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            [detailVC setMainGoodsUrl:url goodsID:entity.jump_parametric];
            [self.mainVC.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 6://dm商品列表或瀑布流
        {
            NSArray *params = [entity.jump_parametric componentsSeparatedByString:@":"];
            [[PSNetTrans getInstance]get_DM_Info:self.mainVC DMId:[params objectAtIndex:0]];
        }
            break;
            
        default:
            break;
    }
}

-(void)titleAction:(id)sender {
    [MTA trackCustomKeyValueEvent:EVENT_ID25 props:nil]; 
    
    NSString *jump_type = categoryEntity.title.jump_type;
    if (![jump_type isEqualToString:@"6"]) {
        [[YHAppDelegate appDelegate].mytabBarController hidesTabBar:YES animated:YES];
    }
    switch ([jump_type integerValue]) {
        case 1://品类
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.title.title;
            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"category" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_category_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = categoryEntity.title.title;
//            [proVC setParamerWihtType:@"5" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 2://品牌
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.title.title;
            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"brand" forKey:@"type"];
            [dic setValue:[params objectAtIndex:0] forKey:@"bu_brand_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = categoryEntity.title.title;
//            [proVC setParamerWihtType:@"4" Id:[params objectAtIndex:0] tag:0];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 3://主题标签
        {
            YHGoodsTabViewController *vc = [[YHGoodsTabViewController alloc] init];
            vc.navigationItem.title = categoryEntity.title.title;
            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            vc.navigationItem.title = [params objectAtIndex:1];
            [dic setValue:@"tag" forKey:@"type"];
            [dic setValue:@"0" forKey:@"bu_id"];
            [dic setValue:[params objectAtIndex:0] forKey:@"tag_id"];
            [dic setValue:@"default" forKey:@"order"];
            [dic setValue:jump_type forKey:@"jump_type"];
            [vc setRequstParams:dic];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
//            YHPromotionViewController *proVC = [[YHPromotionViewController alloc]init];
//            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
//            proVC.navigationItem.title = categoryEntity.title.title;
//            [proVC setParamerWihtType:@"7" Id:@"" tag:[[params objectAtIndex:0] integerValue]];
//            [self.mainVC.navigationController pushViewController:proVC animated:YES];
        }
            break;
        case 4://搜索
        {
            YHSearchResultsViewController * srvc = [[YHSearchResultsViewController alloc]init ];
            srvc.view.backgroundColor = [UIColor clearColor];
            srvc.navigationItem.title = categoryEntity.image.jump_parametric;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:categoryEntity.image.jump_parametric forKey:@"key"];
            [params setValue:@"0" forKey:@"bu_id"];
            [params setValue:@"default" forKey:@"order"];
            [params setValue:@"search" forKey:@"type"];
            [params setValue:jump_type forKey:@"jump_type"];
            [srvc setRequstParams:params];
            [self.mainVC.navigationController pushViewController:srvc animated:YES];
            
//            YHWebGoodListViewController *searchResult = [[YHWebGoodListViewController alloc] init];
//            [searchResult setParamerWihtType:@"6" Id:categoryEntity.title.jump_parametric];
//            [self.mainVC.navigationController pushViewController:searchResult animated:YES];
        }
            break;
        case 5://商品详情
        {
            YHGoodsDetailViewController *detailVC = [[YHGoodsDetailViewController alloc]init];
            NSString *url = [NSString stringWithFormat:GOODS_DETAIL,categoryEntity.title.jump_parametric,[UserAccount instance].session_id,[UserAccount instance].region_id,[[NSUserDefaults standardUserDefaults ] objectForKey:@"bu_code"]];
            [detailVC setMainGoodsUrl:url goodsID:categoryEntity.title.jump_parametric];
            [self.mainVC.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 6://dm商品列表或瀑布流
        {
            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
            [[PSNetTrans getInstance]get_DM_Info:self.mainVC DMId:[params objectAtIndex:0]];
        }
            break;
        case 7://固定抢购
        {
            YHFixedToSnapUpViewController *vc = [[YHFixedToSnapUpViewController alloc] init];
            vc.Forward = YES;
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8://灵活抢购
        {
            YHFlexibleToSnapUpViewController *vc = [[YHFlexibleToSnapUpViewController alloc] init];
            vc.Forward = YES;
            NSArray *params = [categoryEntity.title.jump_parametric componentsSeparatedByString:@":"];
            vc.activity_id = [params objectAtIndex:0];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

@end
