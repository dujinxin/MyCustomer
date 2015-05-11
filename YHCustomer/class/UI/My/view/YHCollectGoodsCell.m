//
//  YHCollectGoodsCell.m
//  YHCustomer
//
//  Created by kongbo on 13-12-21.
//  Copyright (c) 2013年 富基融通. All rights reserved.
//

#import "YHCollectGoodsCell.h"
/******************************************************************************/
/*  用于在UILabel上画删除线  */
/******************************************************************************/
@interface UILabelStrike :UILabel
{
    BOOL isWithStrikeThrough;
}

@property (nonatomic,assign) BOOL isWithStrikeThrough;
@end

//#import"UILabelStrike.h"
@implementation UILabelStrike

@synthesize isWithStrikeThrough;

- (void)drawRect:(CGRect)rect
{
    if (isWithStrikeThrough)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        CGFloat black[4] = {0.5f, 0.5f, 0.5f, 1.0f};
        CGContextSetStrokeColor(c, black);
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp );
        CGContextAddLineToPoint(c, self.bounds.origin.x + self.bounds.size.width, halfWayUp);
        CGContextStrokePath(c);
    }
    
    [super drawRect:rect];
}

@end
@implementation YHCollectGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:10].CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [PublicMethod colorWithHexValue:0xf8f8f8 alpha:10];
        [self addCellView];
    }
    return self;
}

-(void)addCellView
{
    //活动图片
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 122.5)];
    image.contentMode = UIViewContentModeScaleToFill;
    image.layer.borderColor = [PublicMethod colorWithHexValue:0xeeeeee alpha:1.0].CGColor;
    image.layer.borderWidth = 0.5;
    [self.contentView addSubview:image];
    self._dmImage = image;
    //
    UILabel *city = [[UILabel alloc]initWithFrame:CGRectMake(0, 82.5, SCREEN_WIDTH, 40)];
    city.textAlignment = NSTextAlignmentCenter;
    city.textColor = [PublicMethod colorWithHexValue:0x000000 alpha:1.0];
    city.font = [UIFont systemFontOfSize:18.0];
    city.backgroundColor = [PublicMethod colorWithHexValue:0xffffff alpha:0.95];
    [self.contentView addSubview:city];
    self._dmCity = city;
    
    //图片
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 90, 90)];
    [self.contentView addSubview:logoImage];
    self._logoImage = logoImage;
    
    //商品信息
    UILabel *goodInfo = [[UILabel alloc]initWithFrame:CGRectMake(self._logoImage.right+14, 10, SCREEN_WIDTH - self._logoImage.width-15, 40)];
    goodInfo.backgroundColor = [UIColor clearColor];
    goodInfo.font = [UIFont systemFontOfSize:15.0];
    goodInfo.textColor = RGBCOLOR(51, 51, 51);
    goodInfo.lineBreakMode = UILineBreakModeWordWrap;
    goodInfo.numberOfLines = 0;
    [self.contentView addSubview:goodInfo];
    self._goodInfo = goodInfo;
    //说明
    UILabel * illustrate = [PublicMethod addLabel:CGRectMake(image.right+10, goodInfo.bottom, goodInfo.width, 20) setTitle:@"" setBackColor:[PublicMethod colorWithHexValue:0x398cdd alpha:1.0] setFont:[UIFont systemFontOfSize:10.0]];
    illustrate.backgroundColor = [UIColor clearColor];
    //    illustrate.hidden = YES;
    illustrate.textColor = [PublicMethod colorWithHexValue:0xfc5860 alpha:1.0];
    illustrate.textAlignment = NSTextAlignmentLeft;
    //    illustrate.font = [UIFont boldSystemFontOfSize:13.0];
    [self.contentView addSubview:illustrate];
    self._illustrate = illustrate;
    //促销
    //限
    UILabel * limit = [[UILabel alloc]initWithFrame: CGRectMake(self._logoImage.right+14, self._illustrate.bottom, 18, 18)];
    limit.backgroundColor = [PublicMethod colorWithHexValue:0xea49ce alpha:1.0];
    limit.hidden = YES;
    limit.text = @"限";
    limit.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    limit.textAlignment = NSTextAlignmentCenter;
    limit.font = [UIFont boldSystemFontOfSize:13.0];
    [self.contentView addSubview:limit];
    self._limit = limit;
    //专享
    UILabel * special = [[UILabel alloc]initWithFrame: CGRectMake(self._logoImage.right+14, self._illustrate.bottom, 32, 18)];
    special.backgroundColor = [PublicMethod colorWithHexValue:0x53d769 alpha:1.0];
    special.hidden = YES;
    special.text = @"专享";
    special.font = [UIFont boldSystemFontOfSize:13.0];
    special.textColor = [PublicMethod colorWithHexValue:0xffffff alpha:1.0];
    special.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:special];
    self._special = special;

    //价格
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(self._logoImage.right+14, self._goodInfo.bottom+30, 100, 20)];
    price.backgroundColor = [UIColor clearColor];
    price.textColor = RGBCOLOR(231, 96, 73);
    price.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:price];
    self._price = price;
    
    //原价
    UILabelStrike *originalPrice = [[UILabelStrike alloc]initWithFrame:CGRectMake(self._price.right-25, self._price.top+3, 200, 20)];
    originalPrice.backgroundColor = [UIColor clearColor];
    originalPrice.isWithStrikeThrough = YES;
    originalPrice.font = [UIFont systemFontOfSize:12];
    originalPrice.textColor = RGBCOLOR(141, 141, 141);
    [self.contentView addSubview:originalPrice];
    self._originalPrice = originalPrice;
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame = CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-50, 30, 30);
    [cartBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn_selected"] forState:UIControlStateHighlighted];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(addCart) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cartBtn];
    self.cart = cartBtn;
    
    UILabel *cartStatus = [PublicMethod addLabel:CGRectMake(SCREEN_WIDTH-50, originalPrice.bottom-50, 50, 30) setTitle:@"补货中" setBackColor:[UIColor orangeColor] setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:cartStatus];
    self.labelCartStatus = cartStatus;
    
    UILabel *goodsCity = [PublicMethod addLabel:CGRectMake(SCREEN_WIDTH-80, self._price.top+1, 60, 20) setTitle:@"" setBackColor:RGBCOLOR(231, 96, 73) setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:goodsCity];
    self._goodsCity = goodsCity;
}

- (void)drawRect:(CGRect)rect { CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect); //上分割线， CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"ffffff"].CGColor); CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
//    [PublicMethod colorWithHexValue1:@"#e2e2e2"]
    CGContextSetStrokeColorWithColor(context, [PublicMethod colorWithHexValue1:@"#e2e2e2"].CGColor); CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
    
}
-(void)setGoodsCellData:(GoodsEntity *)entity
{
    self.entity = entity;
    [self.cart setHidden:YES];
    [self.labelCartStatus setHidden:YES];
    
    [self._dmImage setHidden:YES];
    [self._dmCity setHidden:YES];
    [self._goodInfo setHidden:NO];
    [self._logoImage setHidden:NO];
    [self._originalPrice setHidden:NO];
    [self._price setHidden:NO];
    [self._goodsCity setHidden:NO];
    [self._illustrate setHidden:NO];
    [self._logoImage setImageWithURL:[NSURL URLWithString:entity.goods_image] placeholderImage:[UIImage imageNamed:@"goods_default"]];
    if (entity.goods_name.length > 0) {
        self._goodInfo.text = entity.goods_name;
    }else {
        self._goodInfo.text = @"未命名";
    }
    CGSize size ;
    size = [self._goodInfo.text sizeWithFont:self._goodInfo.font constrainedToSize:CGSizeMake(self._goodInfo.frame.size.width, 40) lineBreakMode:NSLineBreakByWordWrapping];
    self._goodInfo.frame = CGRectMake(self._goodInfo.frame.origin.x, self._goodInfo.frame.origin.y, self._goodInfo.frame.size.width, size.height);
//    entity.goods_introduction = @"说明性文字";
//    entity.limit_the_purchase_type = @"11";
//    entity.is_or_not_salse = @"1";
    //说明
    if (self._goodInfo.frame.size.height > 20 && (entity.goods_introduction && entity.goods_introduction.length != 0) && (self.entity.is_or_not_salse.integerValue == 1 || self.entity.limit_the_purchase_type.integerValue != 0)){
        self._logoImage.frame = CGRectMake(5, 20, 90, 90);
        self._goodInfo.frame = CGRectMake(self._goodInfo.frame.origin.x, self._goodInfo.frame.origin.y , self._goodInfo.frame.size.width, 40);
        self._illustrate.frame = CGRectMake(self._logoImage.right+10, self._goodInfo.bottom, self._goodInfo.width, 20);
        self._illustrate.text = entity.goods_introduction;
        self._illustrate.hidden = NO;
        
        self._price.frame = CGRectMake(self._logoImage.right+14, self._goodInfo.bottom+50, 100, 20);
        self._originalPrice.frame = CGRectMake(self._price.right-25, self._price.top+3, 200, 20);
        self._goodsCity.frame = CGRectMake(SCREEN_WIDTH-80, self._price.top+1,60, 20);
        self.cart.frame = CGRectMake(SCREEN_WIDTH-50, self._originalPrice.bottom-30, 30, 30);
        self.labelCartStatus.frame = CGRectMake(SCREEN_WIDTH-50, self._originalPrice.bottom-30, 50, 30);
        [self setSpecialLimitView:self._illustrate.bottom];
    }else{
        self._logoImage.frame = CGRectMake(5, 10, 90, 90);
        if (self._goodInfo.frame.size.height > 20) {
            self._goodInfo.frame = CGRectMake(self._goodInfo.frame.origin.x, self._goodInfo.frame.origin.y , self._goodInfo.frame.size.width, 40);
            self._illustrate.frame = CGRectMake(self._logoImage.right+10, self._goodInfo.bottom, self._goodInfo.width, 20);
            if (entity.goods_introduction && entity.goods_introduction.length != 0) {
                self._illustrate.text = entity.goods_introduction;
                self._illustrate.hidden = NO;
            }else{
                self._illustrate.hidden = YES;
                [self setSpecialLimitView:self._goodInfo.bottom];
            }
            self._price.frame = CGRectMake(self._logoImage.right+14, self._goodInfo.bottom+30, 100, 20);
        }else{
            self._goodInfo.frame = CGRectMake(self._goodInfo.frame.origin.x, self._goodInfo.frame.origin.y , self._goodInfo.frame.size.width, 20);
            self._illustrate.frame = CGRectMake(self._logoImage.right+10, self._goodInfo.bottom, self._goodInfo.width, 20);
            if (entity.goods_introduction && entity.goods_introduction.length != 0) {
                self._illustrate.text = entity.goods_introduction;
                self._illustrate.hidden = NO;
            }else{
                self._illustrate.hidden = YES;
            }
            [self setSpecialLimitView:self._illustrate.bottom];
            self._price.frame = CGRectMake(self._logoImage.right+14, self._goodInfo.bottom+50, 100, 20);
        }
        
        self._originalPrice.frame = CGRectMake(self._price.right-25, self._price.top+3, 200, 20);
        self._goodsCity.frame = CGRectMake(SCREEN_WIDTH-80, self._price.top+1,60, 20);
        self.cart.frame = CGRectMake(SCREEN_WIDTH-50, self._originalPrice.bottom-30, 30, 30);
        self.labelCartStatus.frame = CGRectMake(SCREEN_WIDTH-50, self._originalPrice.bottom-30, 50, 30);
    }
    
    if ([entity.out_of_stock intValue] == 1) {
        [self.cart setHidden:YES];
        [self.labelCartStatus setHidden:NO];
    }else{
        [self.cart setHidden:NO];
        [self.labelCartStatus setHidden:YES];
    }
    //0加入购物车，1立即购买
    if (entity.transaction_type.integerValue == 0) {
        [self.cart setBackgroundImage:[UIImage imageNamed:@"cart_btn"] forState:UIControlStateNormal];
    }else{
        [self.cart setBackgroundImage:[UIImage imageNamed:@"cart_btn_shopping"] forState:UIControlStateNormal];
    }
    self._originalPrice.text = [NSString stringWithFormat:@"￥%@",entity.price];
    self._price.text = [NSString stringWithFormat:@"￥%@",entity.discount_price];
    self._goodsCity.text = entity.region_name;
    
    // 现价 >= 原价 将原价隐藏
    if ([entity.discount_price floatValue] >= [entity.price floatValue]) {
        self._originalPrice.hidden = YES;
    }
    
    //调整位置
    self._originalPrice.size = [self._originalPrice.text sizeWithFont:self._originalPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
}

-(void)setDmCellData:(DmEntity *)entity {
    self.labelCartStatus.hidden = YES;
    [self.cart setHidden:YES];
    [self._goodInfo setHidden:YES];
    [self._logoImage setHidden:YES];
    [self._originalPrice setHidden:YES];
    [self._price setHidden:YES];
    [self._goodsCity setHidden:YES];
    [self._dmImage setHidden:NO];
    [self._dmCity setHidden:NO];
    [self._dmImage setImageWithURL:[NSURL URLWithString:entity.dm_image] placeholderImage:[UIImage imageNamed:@"dm_default"]];
    [self._dmCity setText:entity.region_name];
    
    [self._special setHidden:YES];
    [self._limit setHidden:YES];
    [self._illustrate setHidden:YES];

}

-(void)addCart {
    if (![self.entity.region_id isEqualToString:[UserAccount instance].region_id]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您目前在%@站，要操作%@收藏的活动，请点击'切换城市'，将为您切换到%@站!",[UserAccount instance].location_CityName,self.entity.region_name,self.entity.region_name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"切换城市", nil];
        alert.tag = 1000;
        
        [alert show];
        
        return;
    }

    [MTA trackCustomKeyValueEvent:EVENT_ID5 props:nil];

    //加入购物车
    if (self.entity.transaction_type.integerValue == 0){
        [[NetTrans getInstance] addCart:self GoodsID:self.entity.goods_id Total:@"1"];
    }//立即购买
    else{
        if (self.cartBlock)
        {
            self.cartBlock (self.entity.goods_id,@"1");
        }
    }
}

#pragma mark - privateMethod
- (void)setSpecialLimitView:(CGFloat)top{
    //限购
    if (self.entity.is_or_not_salse.integerValue == 1){
        self._special.hidden = NO;
        self._special.frame = CGRectMake(self._logoImage.right+14, top, 32, 18);
        if (self.entity.limit_the_purchase_type.integerValue != 0) {
            self._limit.hidden = NO;
            self._limit.frame = CGRectMake(self._special.right+5, top, 18, 18);
        }else{
            self._limit.hidden = YES;
        }
    }else{
        self._special.hidden = YES;
        if (self.entity.limit_the_purchase_type.integerValue != 0) {
            self._limit.hidden = NO;
            self._limit.frame = CGRectMake(self._logoImage.right+14, top, 18, 18);
        }else{
            self._limit.hidden = YES;
        }
    }
}
#pragma mark ----------------------------------------------------UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000 && buttonIndex == 1) {
        
//        [UserAccount instance].region_id = self.entity.region_id;
//        [UserAccount instance].location_CityName = self.entity.region_name;
//        [[UserAccount instance] saveAccount];
    
        if (self.collectBlock)
        {
            self.collectBlock();
        }
    }
}


#pragma mark --------------------------Request Delegate
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [[iToast makeText:@"添加到购物车成功"]show];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *num = [userDefault objectForKey:@"cartNum"];
    int numInt = [num intValue];
    if (num && numInt>=0) {
        numInt++;
        [userDefault setObject:[NSString stringWithFormat:@"%d",numInt] forKey:@"cartNum"];
        [[YHAppDelegate appDelegate] changeCartNum:[NSString stringWithFormat:@"%d",numInt]];
    } else if (num == nil) {
        numInt = 1;
        [userDefault setObject:[NSString stringWithFormat:@"%d",numInt] forKey:@"cartNum"];
        [[YHAppDelegate appDelegate] changeCartNum:[NSString stringWithFormat:@"%d",numInt]];
    }
    
    
    //刷新购物车
    if (self.cartBlock) {
        self.cartBlock (nil,nil);
    }
}

-(void)requestFailed:(int)nTag withStatus:(NSString *)status withMessage:(NSString *)errMsg
{
    [[iToast makeText:errMsg]show];
}

@end
