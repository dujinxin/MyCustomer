//
//  POPDViewController.h
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef MB_STRONG
#if __has_feature(objc_arc)
#define MB_STRONG strong
#else
#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
#define MB_WEAK weak
#elif __has_feature(objc_arc)
#define MB_WEAK unsafe_unretained
#else
#define MB_WEAK assign
#endif
#endif

#import "BuListEntity.h"

@protocol POPDDelegate <NSObject>

-(void) didSelectRowAtIndexPath:(BuListEntity *)datadic;
@end


@interface POPDViewController : UITableViewController
@property (MB_WEAK) id<POPDDelegate> delegate;

+ (POPDViewController *)shareInstance;

- (id)initWithMenuSections:(NSMutableArray *) menuSections;

@end
