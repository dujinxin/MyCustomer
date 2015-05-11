//
//  GoodDetailEntity.h
//  THCustomer
//
//  Created by lichentao on 13-10-21.
//  Copyright (c) 2013年 efuture. All rights reserved.
//  商品详情for分享用到


/*商品详情字段*/
//6             "id": "1",  //商品ID
//7             "brand": "品牌名称",  //品牌名称
//8             "alias": " 测试商品数据",  //商品名称(别名)
//9             "goods_name": " 测试商品数据",  //商品名称
//10             "price": "100",  //商品原价
//11             "discount_price": "22",  //商品现价
//12             "image_url": {
//    13                 'http://app.tianhong.com/img/goods/a6d9f715d22f59a176c315774be7ed8b02',
//    14                 'http://app.tianhong.com/img/goods/a6d9f715d22f59a176c315774be7ed8b02',
//    15                 'http://app.tianhong.com/img/goods/a6d9f715d22f59a176c315774be7ed8b02'
//    16              },
//17                     "details":"2013-06-08"  ,    //发布日期
//18                     "photo":"http://rainbow.mystore.com.cn/upload/ori/78/49/a6d9f715d22f59a176c315774be7ed8b.png" //图片
//19         }

/*促销详情感情*/
//description = "\U6d4b\U8bd5\U63a8\U9001\U4fc3\U9500";
//"dm_id" = 47;
//"end_date" = "2013-10-31";
//photo = 243a24c0acf38892e4587bd3b58bca4c01;
//"start_date" = "2013-11-29";
//title = " \U63a8\U9001\U4fc3\U9500";

#import <Foundation/Foundation.h>

@interface GoodDetailEntity : NSObject

// 商品详情字段
@property (nonatomic, strong) NSString  *alias;
@property (nonatomic, strong) NSString  *details;
@property (nonatomic, strong) NSString  *photo;
@property (nonatomic, strong) NSString *page_url;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *title;
@end


@interface GoodDetailNetTransobj : NetTransObj

@end