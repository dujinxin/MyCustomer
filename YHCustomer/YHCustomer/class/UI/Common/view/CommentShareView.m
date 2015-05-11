//
//  CommentShareView.m
//  YHCustomer
//
//  Created by lichentao on 14-6-24.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "CommentShareView.h"
#import "GoodDetailEntity.h"
#import "PromotionShareEntity.h"
@implementation CommentShareView
@synthesize dmId;
@synthesize entity;
@synthesize shareTextView;
@synthesize viewC;
- (id)initCommentShareView:(CGRect)frame Dm_ID:(NSString *)dm_id CommentButtonBlock:(CommentButtonBlock)commentBlock1{
    self.dmId = dm_id;
    self.commentBlock = commentBlock1;
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = 1000;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(0, 0, 160, 49);
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_selected"] forState:UIControlStateHighlighted];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.tag = 1001;
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
        commentBtn.frame = CGRectMake(160, 0, 160, 49);
        [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected"] forState:UIControlStateHighlighted];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn"] forState:UIControlStateNormal];
        [commentBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        
    }
    return self;
}
- (id)initCommentShareView:(CGRect)frame viewController:(id)viewController Dm_ID:(NSString *)dm_id CommentButtonBlock:(CommentButtonBlock)commentBlock1
{
    self.dmId = dm_id;
    self.viewC = viewController;
    self.commentBlock = commentBlock1;
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = 1000;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(0, 0, 160, 49);
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn_selected"] forState:UIControlStateHighlighted];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.tag = 1001;
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"bind.png"] forState:UIControlStateNormal];
        commentBtn.frame = CGRectMake(160, 0, 160, 49);
        [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn_selected"] forState:UIControlStateHighlighted];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_btn"] forState:UIControlStateNormal];
        [commentBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        
    }
    return self;
}
- (void)buttonAction:(UIButton *)btn
{
    [MBProgressHUD showHUDAddedTo:[self superview] animated:YES];
    // 点击分享
    if ([[YHAppDelegate appDelegate] checkLogin] == NO) {
        [MBProgressHUD hideAllHUDsForView:[self superview] animated:YES];
        return;
    }
    if (btn.tag == 1000) {
//        [[NetTrans getInstance] buy_GoodDetailForShare:self BuDmOrGoodsId:self.dmId Type:DM_DETAIL_SHARE];
        
        [[NetTrans getInstance]promotion_share:self dm_id:self.dmId];
    }else{
    // 点击评论
        _commentBlock(self.dmId);
    }
}


#pragma mark - connectionDelegate
-(void)requestFailed:(int)nTag withStatus:(NSString*)status withMessage:(NSString*)errMsg
{
    [MBProgressHUD hideAllHUDsForView:[self superview] animated:YES];
    [self showNotice:errMsg];
}
-(void)yhAlertView:(YHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //
//    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
//    NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.qr_code_src]];
//    [defautls setObject:data forKey:@"codeImage"];
//    [defautls synchronize];
    
        UIImage * image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.qr_code_src]]];
        //    将图片写入相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        NSLog(@"baocun");
    
   
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        [[iToast makeText:message ]show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                       message:@"您的照片功能未开启，请去(设置>隐私>照片)开启一下吧！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"message is %@",message);
}
-(void)responseSuccessObj:(id)netTransObj nTag:(int)nTag
{
    [MBProgressHUD hideAllHUDsForView:[self superview] animated:YES];
//    if(t_API_BUY_PLATFORM_PROMOTION_DETAIL == nTag){
//        GoodDetailEntity *goodsEntity = (GoodDetailEntity *)netTransObj;
//        [PublicMethod showShareMainViewWithContent:@"我发现一款永辉移动应用，很不错的，你也看看" title:goodsEntity.title url:goodsEntity.page_url description:goodsEntity.description shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline, nil];
//    }
    if (t_API_PROMOTION_SHARE) {
        [MTA trackCustomKeyValueEvent :EVENT_ID2 props:nil];
        entity = (PromotionShareEntity *)netTransObj;
        

        NSInteger flat = 0;
//        [PublicMethod showCustomShareListViewWithWxContent:entity.wx_content sinaWeiboContent:entity.sina_content flat:flat title:entity.title imageUrl:entity.photo url:entity.page_url description:entity.description qrCodeSrc:entity.qr_code_src block:^(id obj) {
//            
//        } VController:viewC shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
        [PublicMethod showCustomShareListViewWithWxContent:entity.wx_content sinaWeiboContent:entity.sina_content flat:flat title:entity.title imageUrl:entity.photo url:entity.page_url description:entity.description qrCodeSrc:entity.qr_code_src block:^(id obj) {
            
        } VController:viewC AlertViewController:self shareType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeSinaWeibo, nil];
    }
}


@end
