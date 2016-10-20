//
//  CellViewOfDishItemOfSelected.m
//  HotelSystem
//
//  Created by LHJ on 16/3/28.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "CellViewOfDishItemOfSelected.h"
#import "CPublic.h"
#import "DishItemOfSelected.h"

typedef enum : int{

    ViewTag_EditViewPriceDiscount = 1, /* 折扣 */
    ViewTag_EditViewDishNum, /* 数量 */
    ViewTag_AddNum, /* 菜数目 + 1 */
    ViewTag_ReduceNum, /* 菜数目 - 1 */
    ViewTag_Delete, /* 删除这道菜 */
    
} ViewTag;

@implementation CellViewOfDishItemOfSelected
{
    UIView          *m_viewCell;
    UIImageView     *m_imgViewIcon;
    UILabel         *m_labDishName;
    UILabel         *m_labDishPrice;
    EditView        *m_editViewPriceDisCount;
    EditView        *m_editViewNum;
    UIButton        *m_btnDelete;
    UIButton        *m_btnReduceNum;
    UIButton        *m_btnAddNum;
    UIColor         *m_colorLine;
}
@synthesize m_colorDishName;
@synthesize m_colorDishNum;
@synthesize m_colorDishPrice;
@synthesize m_delegate;
@synthesize m_dishItemOfSelected;
@synthesize m_fontDishName;
@synthesize m_fontDishNum;
@synthesize m_fontDishPrice;
//@synthesize m_dishPriceDiscount;
@synthesize m_aryViewScale;

// ==============================================================================================
#pragma mark - 内部使用方法
- (instancetype) init{
    self = [super init];
    if(self != nil){
        [self initData];
    }
    return self;
}
/** 初始化数据 */
- (void) initData
{
    m_aryViewScale = @[@(2), @(1), @(1), @(1), @(0.5)];
    m_colorLine = Color_RGB(200, 200, 200);
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self initMainView];
    [self addAllViewToShow];
}
/** 初始化View */
- (void) initMainView
{
    if(m_viewCell == nil){
        UIView *viewCell = [UIView new];
        [viewCell setBackgroundColor:Color_RGB(255, 255, 255)];
        [viewCell.layer setBorderColor:m_colorLine.CGColor];
        [viewCell.layer setBorderWidth:1.0f];
        [viewCell.layer setMasksToBounds:YES];
        [viewCell.layer setCornerRadius:6.0f];
        m_viewCell = viewCell;
    }
    
    if(m_imgViewIcon == nil){
        UIImageView *imgView = [UIImageView new];
        [imgView setBackgroundColor:Color_Transparent];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        [imgView.layer setCornerRadius:6.0f];
        [imgView.layer setMasksToBounds:YES];
        m_imgViewIcon = imgView;
        imgView = nil;
    }
    
    if(m_labDishName == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:m_fontDishName];
        [lab setTextAlignment:NSTextAlignmentLeft];
        [lab setTextColor:m_colorDishName];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labDishName = lab;
        lab = nil;
    }
    if(m_labDishPrice == nil){
        UILabel *lab = [UILabel new];
        [lab setBackgroundColor:Color_Transparent];
        [lab setNumberOfLines:1];
        [lab setFont:m_fontDishPrice];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setTextColor:m_colorDishPrice];
        [lab setLineBreakMode:NSLineBreakByTruncatingTail];
        m_labDishPrice = lab;
        lab = nil;
    }
    if(m_editViewPriceDisCount == nil){
        EditView *editView = [EditView new];
        [editView setTextAlignment:NSTextAlignmentCenter];
        [editView setTextColor:m_colorDishNum];
        [editView setTextFont:m_fontDishNum];
        [editView setDelegate:(id)self];
        [editView setIsShowClearBtn:NO];
        [editView setEditViewType:EditViewType_SinggleRow];
        [editView setIsInputOnlyNum:YES];
        [editView.layer setBorderWidth:1.0f];
        [editView.layer setBorderColor:Color_RGB(230, 230, 230).CGColor];
        [editView setTag:ViewTag_EditViewPriceDiscount];
        [editView setKeyboardType:UIKeyboardTypeNumberPad];
        m_editViewPriceDisCount = editView;
        editView = nil;
    }
    if(m_editViewNum == nil){
        EditView *editView = [EditView new];
        [editView setTextAlignment:NSTextAlignmentCenter];
        [editView setTextColor:m_colorDishNum];
        [editView setTextFont:m_fontDishNum];
        [editView setDelegate:(id)self];
        [editView setIsShowClearBtn:NO];
        [editView setEditViewType:EditViewType_SinggleRow];
        [editView setIsInputOnlyNum:YES];
        [editView.layer setBorderWidth:1.0f];
        [editView.layer setBorderColor:Color_RGB(230, 230, 230).CGColor];
        [editView setTag:ViewTag_EditViewDishNum];
        [editView setKeyboardType:UIKeyboardTypeNumberPad];
        m_editViewNum = editView;
        editView = nil;
    }
    if(m_btnAddNum == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setTag:ViewTag_AddNum];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:GetImg(@"jiahao") forState:UIControlStateNormal];
        m_btnAddNum = btn;
        btn = nil;
    }
    if(m_btnReduceNum == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setTag:ViewTag_ReduceNum];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:GetImg(@"jianhao") forState:UIControlStateNormal];
        m_btnReduceNum = btn;
        btn = nil;
    }
    if(m_btnDelete == nil){
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:Color_Transparent];
        [btn setTag:ViewTag_Delete];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        [btn setTitleColor:Color_RGB(200, 30, 120) forState:UIControlStateNormal];
        [btn.titleLabel setFont:Font(16)];
        m_btnDelete = btn;
        btn = nil;
    }
}
/** 把所有的View显示到界面上 */
- (void) addAllViewToShow
{
    if(m_viewCell == nil) { return; }
    
    const float spacex_mainView = 10;
    const float spacey_mainView = 16;
    UIView *viewMain = self;
    float x_view = spacex_mainView;
    float y_view = spacey_mainView;
    float w_view = viewMain.bounds.size.width - x_view - spacex_mainView;
    float h_view = viewMain.bounds.size.height - y_view - spacey_mainView;
    
    if(m_viewCell != nil){
        [m_viewCell setFrame:CGRectMake(x_view, y_view, w_view, h_view)];
        [viewMain addSubview:m_viewCell];
    }
    
    const float space_x = 20;
    const float spaceInsert_x = 10;
    const float scaleValue = (m_viewCell.bounds.size.width - space_x*2) / m_aryViewScale.count;
    const float w_imgAndName = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:0] intValue]; // 名字和图片部分
    const float w_discount = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:1] intValue];; // 折扣部分
    const float w_price = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:2] intValue];; // 价格部分
    const float w_num = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:3] intValue];; // 价格部分
//    const float w_btn = scaleValue * [(NSNumber*)[m_aryViewScale objectAtIndex:4] intValue];; // 删除按钮部分
    const float h_tx = [CPublic getTextHeight:@"高" _font:m_fontDishNum] * 6/4;
    
    // ====== 菜图标和菜名 ======
    float x_add = space_x;
//    float w_add = w_imgAndName*4/10;
//    float h_add = w_add *3/4;
    float h_add = m_viewCell.bounds.size.height *7/10;
    float w_add = h_add * 12/10;
    float y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_imgViewIcon != nil){
        [m_imgViewIcon setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        NSString *strPath = [CPublic getLocalAbsolutePathOfRelativePath:[m_dishItemOfSelected getDishIconImgPath]];
        [m_imgViewIcon setImage:[UIImage imageWithContentsOfFile:strPath]];
        [m_viewCell addSubview:m_imgViewIcon];
        x_add += m_imgViewIcon.frame.size.width + spaceInsert_x;
    }
    w_add = w_imgAndName - (x_add - m_imgViewIcon.frame.origin.x);
    h_add = m_viewCell.bounds.size.height;
    y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_labDishName != nil){
        [m_labDishName setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_labDishName setText:[m_dishItemOfSelected getDishName]];
        [m_viewCell addSubview:m_labDishName];
    }
    
    // ====== 菜价格 ======
    x_add = space_x + w_imgAndName;
    w_add = w_price;
    h_add = m_viewCell.bounds.size.height;
    y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_labDishPrice != nil){
        [m_labDishPrice setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_labDishPrice setText:[NSString stringWithFormat:@"%.02f", [m_dishItemOfSelected getDishPrice]]];
        [m_viewCell addSubview:m_labDishPrice];
    }
    
    // ====== 菜折扣 ======
    h_add = h_tx;
    w_add = h_add;
    x_add = space_x + w_imgAndName + w_price + (w_discount - w_add)/2;
    y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_editViewPriceDisCount != nil){
        [m_editViewPriceDisCount setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_editViewPriceDisCount setTextContent:[NSString stringWithFormat:@"%.02f", [m_dishItemOfSelected getDishPriceDiscount]]];
        [m_viewCell addSubview:m_editViewPriceDisCount];
    }
    
    // ====== 菜数量 ======
    // 数字输入框
    h_add = h_tx;
    w_add = h_add;
    x_add = space_x + w_imgAndName + w_price + w_discount + (w_num - w_add)/2;
    y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_editViewNum != nil){
        [m_editViewNum setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_editViewNum setTextContent:[NSString stringWithFormat:@"%i", [m_dishItemOfSelected getDishSelectNum]]];
        [m_viewCell addSubview:m_editViewNum];
    }
    // 减号按钮
    float temp = (w_num - m_editViewNum.bounds.size.width - spaceInsert_x*2) /2;
    h_add = h_tx*3/4;
    h_add = (h_add < temp)? h_add : temp;
    w_add = h_add;
    x_add = m_editViewNum.frame.origin.x - spaceInsert_x - w_add;
    y_add = (m_viewCell.bounds.size.height - h_add)/2;
    if(m_btnReduceNum != nil){
        [m_btnReduceNum setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_viewCell addSubview:m_btnReduceNum];
    }
    // 加号按钮
    x_add = m_editViewNum.frame.origin.x + m_editViewNum.frame.size.width + spaceInsert_x;
    if(m_btnAddNum != nil){
        [m_btnAddNum setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
        [m_viewCell addSubview:m_btnAddNum];
    }
    
    // ====== 删除按钮 ======
//    x_add = space_x + w_imgAndName + w_price + w_discount + w_num;
//    w_add = w_btn;
//    h_add = m_viewCell.bounds.size.height;
//    y_add = (m_viewCell.bounds.size.height - h_add)/2;
//    if(m_btnDelete != nil){
//        [m_btnDelete setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
//        [m_viewCell addSubview:m_btnDelete];
//    }
}
// ==============================================================================================
#pragma mark - 外部调用方法
- (void )setDishItemOfSelected:(DishItemOfSelected*)v_dishItemOfSelected
{
    m_dishItemOfSelected = v_dishItemOfSelected;
    [self addAllViewToShow];
}

// ==============================================================================================
#pragma mark -  动作触发方法
/** 点击按钮触发的方法 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = v_sender;
    switch((ViewTag)(view.tag)){
        case ViewTag_AddNum:{ // 菜数目 + 1
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickBtn_addDishWithDishItem:_sender:)];
                if(bTemp == YES){
                    [m_delegate clickBtn_addDishWithDishItem:m_dishItemOfSelected _sender:(id)self];
                }
            }
            break;
        }
        case ViewTag_ReduceNum:{ // 菜数目 - 1
            if(m_delegate != nil){
                BOOL bTemp = [m_delegate respondsToSelector:@selector(clickBtn_reduceDishWithDishItem:_sender:)];
                if(bTemp == YES){
                    [m_delegate clickBtn_reduceDishWithDishItem:m_dishItemOfSelected _sender:(id)self];
                }
            }
            break;
        }
        case ViewTag_Delete:{ // 删除这道菜
            break;
        }
        default:{
            break;
        }
    }
}

// ==============================================================================================
#pragma mark -  委托协议EditViewDelegate
/** 确定输入内容之后回调这个方法 */
- (void) commitInput:(NSString*)v_strInputText _sender:(id)v_sender
{
//    EditView *editView = v_sender;
    @try{
        float discount = [v_strInputText floatValue];
        if(discount > 0){
        
        }
        if(m_delegate != nil){
            BOOL bTemp = [m_delegate respondsToSelector:@selector(commitNewDiscount:_dishItem:_sender:)];
            if(bTemp == YES){
                [m_delegate commitNewDiscount:discount _dishItem:m_dishItemOfSelected _sender:self];
            }
        }
    }@catch(NSException *e){
        [CPublic ShowDialg:@"输入有误"];
    }
}
// ==============================================================================================
#pragma mark -  委托协议UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

@end
