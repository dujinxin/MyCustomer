//
//  EGOViewCommon.h
//  TableViewRefresh
//
//  Created by  Abby Lin on 12-5-2.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef TableViewRefresh_EGOViewCommonOther_h
#define TableViewRefresh_EGOViewCommonOther_h

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_REGION_HEIGHT_OTHER 65.0f

typedef enum{
	EGOOPullRefreshOtherPulling = 0,
	EGOOPullRefreshOtherNormal,
	EGOOPullRefreshOtherLoading,
} EGOPullRefreshOtherState;

typedef enum{
	EGORefreshOtherHeader = 0,
	EGORefreshOtherFooter
} EGORefreshOtherPos;

@protocol EGORefreshTableOtherDelegate
- (void)egoRefreshTableDidTriggerOtherRefresh:(EGORefreshPos)aRefreshPos;
- (BOOL)egoRefreshTableDataSourceIsOtherLoading:(UIView*)view;
@optional
- (NSDate*)egoRefreshTableDataSourceLastOtherUpdated:(UIView*)view;
@end

#endif
