//
//  PromotionListEntity.h
//  THCustomer
//
//  Created by lichentao on 13-9-9.
//  Copyright (c) 2013年 efuture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DmEntity.h"

@interface PromotionEntity : NSObject
@property (nonatomic, copy) NSString    *_dmId;
@property (nonatomic, copy) NSString    *_description;
@property (nonatomic, copy) NSString    *_dmPhoto;
@property (nonatomic, copy) NSString    *_dmTitle;
@property (nonatomic, copy) NSString    *_dmPublishTime;
@property (nonatomic, copy) NSString    *_commentNum;
@property (nonatomic, copy) NSString    *_laud;
@property (nonatomic, copy) NSString    *region_id;
@property (nonatomic, copy) NSString    *region_name;

@property(nonatomic,copy) NSString *background_color;
@property(nonatomic,copy) NSString *page_type;
@property(nonatomic,copy) NSString *image_url;
@property(nonatomic,copy) NSString *connect_goods;
@end


@interface PromotionCollectListTransObj : NetTransObj

@end