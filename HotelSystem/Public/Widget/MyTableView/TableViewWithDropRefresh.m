//
//  TableViewWithDrop.m
//  MachineModule
//
//  Created by LHJ on 16/1/19.
//  Copyright © 2016年 LHJ. All rights reserved.
//

#import "TableViewWithDropRefresh.h"

@implementation TableViewWithDropRefresh
{
    // ---- 下拉刷新 ----
    EGORefreshTableHeaderView   *m_refreshHeaderView;
    BOOL                        m_bReloading;
    
    BOOL                        m_bIsLayoutView;
    id<UITableViewDelegate>     m_tableViewDelegate;
}
@synthesize m_bIsOpenDropRefresh;
@synthesize m_dropDelete;

// ==============================================================================================
#pragma mark - 继承方法
- (instancetype) initWithFrame:(CGRect)v_frame
{
    self = [super initWithFrame:v_frame];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];

    if(m_bIsLayoutView == YES) { return; }
    [self initLayoutView];
}
// ==============================================================================================
#pragma mark - 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_tableViewDelegate = nil;
    m_dropDelete = nil;
    m_bIsOpenDropRefresh = YES;
    m_bIsLayoutView = NO;
    m_refreshHeaderView = nil;
    m_bReloading = NO;
    [super setDelegate:self];
}
/** 初始化布局View */
- (void) initLayoutView
{
    m_bIsLayoutView = YES;
    
    if(m_bIsOpenDropRefresh != YES) { return; } // 不开启下拉刷新的功能
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    view.m_delegate = (id)self;
    [self addSubview:view];
    m_refreshHeaderView = view;
    
    [m_refreshHeaderView refreshLastUpdatedDate];
}
// ==============================================================================================
#pragma mark - 外部使用方法
- (void) setDelegate:(id<UITableViewDelegate>)v_delegate
{
    m_tableViewDelegate = v_delegate;
    [super setDelegate:v_delegate];
}

// ==============================================================================================
#pragma mark - 委托协议EGORefreshTableHeaderDelegate
- (void)reloadTableViewDataSource
{
    m_bReloading = YES;
}
- (void)doneLoadingTableViewData
{
    //  model should call this when its done loading
    m_bReloading = NO;
    [m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    
    if(m_dropDelete != NULL){
        BOOL bTemp = [m_dropDelete respondsToSelector:@selector(dropRefresh:)];
        if(bTemp == YES){
            [m_dropDelete dropRefresh:(id)self];
        }
    }
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return m_bReloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

// ==============================================================================================
#pragma mark - 委托协议UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    [m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

// ==============================================================================================
#pragma mark - 委托协议UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rs = 0.0f;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: heightForRowAtIndexPath:)];
        if(bTemp == YES){
            rs = [m_tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    return rs;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat rs = 0.0f;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: heightForHeaderInSection:)];
        if(bTemp == YES){
            rs = [m_tableViewDelegate tableView:tableView heightForHeaderInSection:section];
        }
    }
    return rs;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat rs = 0.0f;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: heightForFooterInSection:)];
        if(bTemp == YES){
            rs = [m_tableViewDelegate tableView:tableView heightForFooterInSection:section];
        }
    }
    return rs;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewRS = nil;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: viewForHeaderInSection:)];
        if(bTemp == YES){
            viewRS = [m_tableViewDelegate tableView:tableView viewForHeaderInSection:section];
        }
    }
    return viewRS;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewRS = nil;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: viewForFooterInSection:)];
        if(bTemp == YES){
            viewRS = [m_tableViewDelegate tableView:tableView viewForFooterInSection:section];
        }
    }
    return viewRS;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: didSelectRowAtIndexPath:)];
        if(bTemp == YES){
            [m_tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle styleRS = UITableViewCellEditingStyleNone;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: editingStyleForRowAtIndexPath:)];
        if(bTemp == YES){
            styleRS = [m_tableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
        }
    }
    return styleRS;
}
// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: willBeginEditingRowAtIndexPath:)];
        if(bTemp == YES){
            [m_tableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
        }
    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: didEndEditingRowAtIndexPath:)];
        if(bTemp == YES){
            [m_tableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
        }
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL bRS = NO;
    if(m_tableViewDelegate != nil){
        BOOL bTemp = [m_tableViewDelegate respondsToSelector:@selector(tableView: shouldIndentWhileEditingRowAtIndexPath:)];
        if(bTemp == YES){
            bRS = [m_tableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
        }
    }
    return bRS;
}

@end
