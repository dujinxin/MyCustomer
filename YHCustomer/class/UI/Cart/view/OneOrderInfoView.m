//
//  OneOrderInfoView.m
//  THCustomer
//
//  Created by 任 清阳 on 13-9-12.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import "OneOrderInfoView.h"
#import "YHCartViewController.h"
#import "CartAlertView.h"
#import "UILabelStrikeThrough.h"
#import "YHAlertView.h"

#define LIFTDISTANCE              30.0
#define GOODSIMAGEWIDTH           50.0
#define GOODSIMAGEHEIGHT          50.0

@implementation OneOrderInfoView
@synthesize myEntity;
@synthesize controller;
-(void)dealloc
{
    [myEntity release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)selectOne:(id)sender{
    if (self.myEntity.pay_type.integerValue == 0) {
        if ([controller isKindOfClass:[YHCartViewController class]]) {
            [controller selectOneGood:myEntity Type:@"1"];// 未选中
        }
    }else{
        if ([controller isKindOfClass:[YHCartViewController class]]) {
            [controller selectOneGood:myEntity Type:@"0"];// 选中
        }
    }
}

// 设置商品属性 － 我的购物车
- (void)setOrderCartInfoGoodEntity:(GoodsEntity *)entity{
    self.myEntity = entity;
    // Initialization code
    allSelectBtn = [PublicMethod addButton:CGRectMake(5, 34, 18, 18) title:nil backGround:nil setTag:106 setId:self selector:@selector(selectOne:) setFont:nil setTextColor:nil];
    if (entity.pay_type.integerValue == 0) {
        [allSelectBtn setBackgroundImage:[UIImage imageNamed:@"agreeArg.png"] forState:UIControlStateNormal];
    }else{
        [allSelectBtn setBackgroundImage:[UIImage imageNamed:@"agreeBg.png"] forState:UIControlStateNormal];
    }
    if (entity.transaction_type.integerValue == 1) {//立即购
        [allSelectBtn setBackgroundImage:[UIImage imageNamed:@"not_agree"] forState:UIControlStateNormal];//agreeBg.png
        [allSelectBtn removeTarget:self action:@selector(selectOne:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (entity.out_of_stock.integerValue == 1) {//缺货
        [allSelectBtn setBackgroundImage:[UIImage imageNamed:@"not_agree"] forState:UIControlStateNormal];
        [allSelectBtn removeTarget:self action:@selector(selectOne:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:allSelectBtn];
    
    //商品图片
    UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(30, 15, GOODSIMAGEWIDTH, GOODSIMAGEHEIGHT)];
    [goodsImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    goodsImageView.tag = 100;
    [self addSubview:goodsImageView];
    [goodsImageView release];
    
    if (entity.out_of_stock.integerValue == 1) {//缺货
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(30, goodsImageView.bottom+7, 100, 10)];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        label.text = @"该商品已售完或无库存";
        label.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:label];
    }
    if (entity.transaction_type.integerValue == 1 && entity.out_of_stock.integerValue == 0) {//立即购
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(30, goodsImageView.bottom+7, 100, 10)];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
        label.text = @"请到商品详情页购买";
        label.font = [UIFont systemFontOfSize:8.0];
        [self addSubview:label];
    }
    
    //商品信息
    UILabel *goodsInfo =[[UILabel alloc] initWithFrame:CGRectMake(90, 10, 170, 35)];
    goodsInfo.backgroundColor=[UIColor clearColor];
    goodsInfo.textColor = [PublicMethod colorWithHexValue:0x333333 alpha:1.0];
    goodsInfo.numberOfLines=2;;
    goodsInfo.lineBreakMode = UILineBreakModeWordWrap;
    goodsInfo.tag = 101;
    goodsInfo.text = @"三星电子信息显示屏幕2.0三星电子信息显示屏幕2.三星电子信息显示屏幕2.三星电子信息显示屏幕2.三星电子信息显示屏幕2.三星电子信息显示屏幕2.";
    goodsInfo.font =[UIFont systemFontOfSize:14.0];
    [self addSubview:goodsInfo];
    [goodsInfo release];
    
    //商品价格
    UILabel *goodsDisPrice =[[UILabel alloc] initWithFrame:CGRectMake(95, 55, 80,18)];
    goodsDisPrice.backgroundColor=[UIColor clearColor];
    goodsDisPrice.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    goodsDisPrice.tag = 102;
    goodsDisPrice.text =[NSString stringWithFormat:@"￥%@",@"100"];
    goodsDisPrice.font =[UIFont systemFontOfSize:12.0];
    [self addSubview:goodsDisPrice];
    [goodsDisPrice release];
    
    // 商品原价
    UILabelStrikeThrough *goodsOriginPrice = [[UILabelStrikeThrough alloc] initWithFrame:CGRectMake(170, 56, 100, 18)];
    goodsOriginPrice.isWithStrikeThrough = YES;
    goodsOriginPrice.backgroundColor = [UIColor clearColor];
    goodsOriginPrice.tag = 105;
    goodsOriginPrice.text =[NSString stringWithFormat:@"￥%@",@"100"];
    goodsOriginPrice.font =[UIFont systemFontOfSize:10.0];
    goodsOriginPrice.textColor = [PublicMethod colorWithHexValue:0x666666 alpha:1.0];
    CGSize size =  [PublicMethod getLabelSize:[NSString stringWithFormat:@"¥%.2f",[entity.price floatValue]] font:goodsOriginPrice.font constrainedToSize:CGSizeMake(100, 18) lineBreakMode:NSLineBreakByCharWrapping];
    goodsOriginPrice.width = size.width;
    [self addSubview:goodsOriginPrice];
    [goodsOriginPrice release];
    
    //商品数量
    UILabel *goodsNum =[[UILabel alloc] initWithFrame:CGRectMake(275, 30, 24,24)];
    goodsNum.userInteractionEnabled = YES;
    goodsNum.layer.masksToBounds = YES;
    goodsNum.layer.borderWidth = 1.0;
    goodsNum.layer.borderColor = [PublicMethod colorWithHexValue:0xcccccc alpha:1.0].CGColor;
    goodsNum.backgroundColor= [UIColor whiteColor];
    goodsNum.textColor =[UIColor blackColor];
    goodsNum.textAlignment = NSTextAlignmentCenter;
    goodsNum.tag = 103;
    goodsNum.text = [NSString stringWithFormat:@"%@",entity.goodNum];
    goodsNum.font =[UIFont systemFontOfSize:12.0];
    goodsNum.textColor = [UIColor blackColor];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]init];
    [ges addTarget:self action:@selector(chageGoodsNumWithAlert)];
    [goodsNum addGestureRecognizer:ges];
    [self addSubview:goodsNum];
    
    [goodsImageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    goodsInfo.text =[NSString stringWithFormat:@"%@",entity.goods_name];
    goodsDisPrice.text = [NSString stringWithFormat:@"¥%.2f",[entity.discount_price floatValue]];
    goodsOriginPrice.text = [NSString stringWithFormat:@"¥%.2f",[entity.price floatValue]];
    
    // 现价 》 原价
    if ([entity.discount_price floatValue] >= [entity.price floatValue]) {
        goodsOriginPrice.hidden = YES;
    }
    
}

// 设置商品属性 － 我的订单
- (void)setOrderInfoGoodEntity:(GoodsEntity *)entity :(id)controller1 SetOrderType:(int)type{
    
    // 已完成
    if (type == 2) {
        UITapGestureRecognizer *regCognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGoodsDetail:)];
        [self addGestureRecognizer:regCognizer];
        self.controller = controller1;
    }
    self.myEntity = entity;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width-6, self.frame.size.height-6)];
    bg.image =[UIImage imageNamed:@"cart_myOrderCellBg.png"];
    [self addSubview:bg];
    [bg release];

    //商品图片
    UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 5, GOODSIMAGEWIDTH, GOODSIMAGEHEIGHT)];
    [goodsImageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    goodsImageView.tag = 100;
    [self addSubview:goodsImageView];
    [goodsImageView release];
    
    //商品信息
    UILabel *goodsInfo =[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 170, 35)];
    goodsInfo.backgroundColor=[UIColor clearColor];
    goodsInfo.textColor =[UIColor blackColor];
    goodsInfo.numberOfLines=2;;
    goodsInfo.lineBreakMode = UILineBreakModeWordWrap;
    goodsInfo.tag = 101;
    goodsInfo.text =entity.goods_name;
    goodsInfo.font =[UIFont systemFontOfSize:14.0];
    [self addSubview:goodsInfo];
    [goodsInfo release];
    
    //商品价格
    UILabel *goodsDisPrice =[[UILabel alloc] initWithFrame:CGRectMake(230, 17, 70,16)];
    goodsDisPrice.backgroundColor=[UIColor clearColor];
    goodsDisPrice.textColor =[UIColor redColor];
    goodsDisPrice.tag = 102;
    goodsDisPrice.text =[NSString stringWithFormat:@"¥ %.2f",[entity.discount_price floatValue]];
    goodsDisPrice.font =[UIFont systemFontOfSize:14.0];
    goodsDisPrice.textAlignment = NSTextAlignmentRight;
    [self addSubview:goodsDisPrice];
    [goodsDisPrice release];
    
    //商品数量
    UILabel *goodsNum =[[UILabel alloc] initWithFrame:CGRectMake(240, 34, 60,18)];
    goodsNum.textColor =[UIColor blackColor];
    goodsNum.textAlignment = NSTextAlignmentCenter;
    goodsNum.tag = 103;
    goodsNum.text =[NSString stringWithFormat:@"x %@",entity.goodNum];
    goodsNum.font =[UIFont systemFontOfSize:13.0];
    goodsNum.textColor = [UIColor blackColor];
    [self addSubview:goodsNum];
    [goodsNum release];
    // 已完成中有accessimg
    if (type == 2) {
        UIImageView *accessImg = [PublicMethod addImageView:CGRectMake(300, 30, 15, 18) setImage:@"cart_myOrderAccess.png"];
        [self addSubview:accessImg];
    }
}

// 设置商品属性 － 退货商品
- (void)setReturnInfoGoodEntity:(GoodsEntity *)entity{
    self.myEntity = entity;
    [self removeAllSubviews];
    self.backgroundColor = [UIColor whiteColor];
    //商品图片
    UIImageView *goodsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [goodsImageView setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"cart_Good_Default.png"]];
    goodsImageView.tag = 100;
    [self addSubview:goodsImageView];
    [goodsImageView release];
    
    //商品信息
    UILabel *goodsInfo =[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 170, 20)];
    goodsInfo.backgroundColor=[UIColor clearColor];
    goodsInfo.textColor =[UIColor blackColor];
    goodsInfo.numberOfLines=2;;
    goodsInfo.lineBreakMode = UILineBreakModeWordWrap;
    goodsInfo.tag = 101;
    goodsInfo.text =entity.goods_name;
    goodsInfo.font =[UIFont systemFontOfSize:14.0];
    [self addSubview:goodsInfo];
    [goodsInfo release];
    
    //商品数量
    UILabel *goodsDisPrice =[[UILabel alloc] initWithFrame:CGRectMake(60, 35, 100,18)];
    goodsDisPrice.backgroundColor=[UIColor clearColor];
    goodsDisPrice.textColor =[UIColor blackColor];
    goodsDisPrice.tag = 102;
    goodsDisPrice.text =[NSString stringWithFormat:@"已退货数量 %@",entity.goodNum];
    goodsDisPrice.font =[UIFont systemFontOfSize:12.0];
    [self addSubview:goodsDisPrice];
    [goodsDisPrice release];
    
    // line
    UIView *bgLine = [PublicMethod addBackView:CGRectMake(0, 59, 320, 1) setBackColor:LIGHT_GRAY_COLOR];
    [self addSubview:bgLine];
}


- (void)gotoGoodsDetail:(id)sender{
    [self.controller goGoodsDetailWithBuyFinish:self.myEntity];
}

// 弹出对话框 － 修改
- (void)chageGoodsNumWithAlert{
    CartAlertView *alert = [[CartAlertView alloc]init];
    alert.goodsNumField.text = self.myEntity.goodNum;
    [alert setOnButtonTouchUpInside:^(NSString *goodsNum) {
        NSLog(@"goodsNum = %@",goodsNum);
        [controller modifyCartGoodsNum:self.myEntity.cart_id GoodsNum:goodsNum];
    }];
    [alert show];
}


@end
