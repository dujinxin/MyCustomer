//
//  YHApplyReturnGoodsViewDeliveredController.h
//  YHCustomer
//
//  Created by kongbo on 14-5-2.
//  Copyright (c) 2014年 富基融通. All rights reserved.
//

#import "YHRootViewController.h"
#import "YHApplyReturnGoodsViewController.h"
#import "OrderEntity.h"
#import "GoodsEntity.h"
#import "MyPickerView.h"

@interface YHApplyReturnGoodsViewDeliveredController : YHRootViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate> {
    UIScrollView *scrollView;//整个视图的背景
    NSString *payMethod;
    UIButton *submitBtn;
    MyPickerView *pickView;
    MyOrderEntity *orderEntity;
    
    
    UIView *bg2;//退货商品
    UIScrollView *uploadView;//上传商品图片滑动视图
    UIView *uploadBg;//上传商品图片背景
    NSString *goods_info;//退货商品字符串拼接
    
    
    UIView *bg3;//退货原因
    UIButton *btn;//退货原因
    UITextField *returnReason;
    UITextField *returnInfo;//退货说明
    
    NSMutableArray *reasonArray;//退货原因
    UIButton *addBtn;
    NSString *returns_goods_images;//上传图片字符串拼接
    NSMutableArray *returns_goods_images_array;//id
    NSMutableArray *returns_goods_images_url_array;//url
    UILabel *imageCount;
    NSString *reason_code;
    NSString *reason_name;
    NSString *reason_info;//退货说明
    
    UIView *bg4;//退货账号
    NSString *returns_name;
    NSString *returns_account;
    NSString *returns_card_num;
    UITextField *name;
    UITextField *accout;
    UITextField *bank;
    
    
    
    UIView *bg5;//退货方式
    UIButton *returnMethodBtn;//退货方式
    UILabel *top;
    UILabel *mid;
    UILabel *bottom;
    NSMutableArray *returnMethodArray;//退货方式
    UIImageView *returnMethodAcess;
    NSMutableArray    *arrAddress;//取货地址列表
    NSString *_order_address_id;
    NSString *_name;
    NSString *_tel;
    NSString *_logistics_area_name;
    NSString *_logistics_address;
    UIView *yellowBg;//
    NSString *returns_method;
    NSString *store_name;
    NSString *store_add;
    BOOL refreshUI;
}
@property (nonatomic,strong)NSString *model;
@property (nonatomic, strong) GoodsListEntity    *listEntity;
@property (nonatomic, strong) SubmitSucessBlock submitBlock;
@property (nonatomic, strong) NSMutableArray *returnGoodsArray;
-(void)setData:(MyOrderEntity *)entity;

@end
