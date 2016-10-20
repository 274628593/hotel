//
//  TableViewWithDrop.h
//  MachineModule
//
//  Created by LHJ on 16/1/19.
//  Copyright © 2016年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol DropRefreshDelegate;

/** 带有下拉刷新的列表UI控件 */
@interface TableViewWithDropRefresh : UITableView<UITableViewDelegate, EGORefreshTableHeaderDelegate>

// ==============================================================================================
#pragma mark - 外部调用变量
/** 下拉刷新的委托 */
@property(nonatomic, weak, setter=setDropRefreshDelegate:, getter=getDropRefreshDelegate) id<DropRefreshDelegate> m_dropDelete;

/** 是否开启下拉刷新功能，默认YES */
@property(nonatomic, assign, setter=setIsOpenDropRefresh:, getter=getIsOpenDropRefresh) BOOL m_bIsOpenDropRefresh;

@end

// ==============================================================================================
#pragma mark - 委托协议
@protocol DropRefreshDelegate<NSObject>

/** 下拉刷新后的调用事件 */
- (void) dropRefresh:(id)v_sender;

@end