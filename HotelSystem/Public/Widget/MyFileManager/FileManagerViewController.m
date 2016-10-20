//
//  FileManagerViewController.m
//  MachineModule
//
//  Created by LHJ on 15/12/22.
//  Copyright © 2015年 LHJ. All rights reserved.
//
#import "FileManagerViewController.h"
#import "CPublic.h"

typedef enum : int{
    ViewTag_NavLeftBtn = 10, /* 顶部栏左按钮 */
    ViewTag_NavRightBtn, /* 顶部栏右按钮 */
    ViewTag_DocBtn, /* 切换文件类型按钮 - 文档 */
    ViewTag_ImgBtn, /* 切换文件类型按钮 - 图片 */
    ViewTag_AllBtn, /* 切换文件类型按钮 - 全部 */
    ViewTag_TableView, /* 文件显示列表 */
    
} ViewTag;

#define Height_NavFileManager   44.0f
#define Font_Text               Font(15.0f)
#define Font_Desc               Font(14.0f)
#define Color_Text              Color_RGB(100, 100, 100)
#define Color_Decr              Color_RGB(120, 120, 120)

@implementation FileManagerViewController
{
    NSArray<HorListItmObj*>                                         *m_aryHorList;
    NSMutableDictionary<NSString*, NSMutableArray<FileItem*>*>      *m_muDicFileList;
    NSMutableDictionary<NSString*, NSMutableArray<FileItemView*>*>  *m_muDicCellView;
    NSMutableArray<FileItemView*>                                   *m_aryShowList;
    NSMutableArray<FileItemView*>                                   *m_muArySelected; // 选中的列表项
}
@synthesize m_delegate;

// ======================================================================================
#pragma mark 基类继承方法
- (instancetype) init
{
    self = [super init];
    [self initData];
    return self;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self getFileListData];
    [self initLayoutView];
}
// ======================================================================================
#pragma mark 内部使用函数
/** 初始化数据 */
- (void) initData
{
    NSMutableArray *muAry = [NSMutableArray new];
    HorListItmObj *itemObj = [HorListItmObj new];
    [itemObj setText:@"全部"];
    [itemObj setID:ViewTag_AllBtn];
    [muAry addObject:itemObj];
    
    itemObj = [HorListItmObj new];
    [itemObj setText:@"文本"];
    [itemObj setID:ViewTag_DocBtn];
    [muAry addObject:itemObj];
    
    itemObj = [HorListItmObj new];
    [itemObj setText:@"图片"];
    [itemObj setID:ViewTag_ImgBtn];
    [muAry addObject:itemObj];
    m_aryHorList = muAry;
}
/** 初始化视图 */
- (void) initLayoutView
{
    // ====== 顶部栏 ======
    UIView *viewMain = self.view;
    float x_add = viewMain.bounds.origin.x;
    float y_add = viewMain.bounds.origin.y;
    float w_add = viewMain.bounds.size.width;
    float h_add = 0;
    [viewMain setBackgroundColor:Color_RGB(250, 250, 250)];
    CGRect frameNav = CGRectMake(x_add, y_add, w_add, h_add);
    UIView *viewNav = (UIView*)[self initNavView:frameNav];
    if(viewNav != nil){
        [viewMain addSubview:viewNav];
        y_add += viewNav.frame.size.height;
    }
    
    // ====== 选择文件类型一栏 ======
    View_HorList *viewHorList = [View_HorList new];
    [viewHorList setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewHorList setBackgroundColor:Color_Transparent];
    [viewHorList setListType:ListType_1];
    [viewHorList setHorList:m_aryHorList];
    [viewHorList setTextColor:Color_RGB(100, 149, 237)];
    [viewHorList setTextFont:Font_Text];
    [viewHorList setDelegate:(id)self];
    [viewHorList initLayoutView];
    [viewMain addSubview:viewHorList];
    y_add += viewHorList.bounds.size.height;
    
    // ====== 顶部列表View ======
    h_add = viewMain.bounds.size.height - y_add;
    UITableView *tvList = [UITableView new];
    [tvList setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [tvList setBackgroundColor:Color_Transparent];
    [tvList setDataSource:(id)self];
    [tvList setDelegate:(id)self];
    [tvList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tvList setTag:ViewTag_TableView];
    [viewMain addSubview:tvList];
}
/** 待重写函数，初始化头部导航栏，当不实现此方法时，用默认的顶部栏 */
- (instancetype) initNavView:(CGRect)v_frameNav
{
    const float heightNav = Height_NavFileManager;
    const float heightStatusBar = (SystemVersonOfIOS >= 7.0)? Height_StatusBar : 0;
    int h_rs = heightStatusBar + heightNav;
    int w_rs = v_frameNav.size.width;
    CGSize sizeRS = CGSizeMake(w_rs, h_rs);
    v_frameNav.size = sizeRS;
    UIView *viewRS = [UIView new];
    [viewRS setFrame:v_frameNav];
    [viewRS setBackgroundColor:Color_RGB(30, 144, 255)];
    [viewRS setUserInteractionEnabled:YES];
    [viewRS setClipsToBounds:YES];
    
    // ====== 导航栏 ======
    float x_add = viewRS.bounds.origin.x;
    float y_add = heightStatusBar;
    float w_add = viewRS.bounds.size.width - x_add*2;
    float h_add = viewRS.bounds.size.height - y_add;
    UIView *viewNav = [UIView new];
    [viewNav setFrame:CGRectMake(x_add, y_add, w_add, h_add)];
    [viewNav setBackgroundColor:Color_Transparent];
    [viewNav setUserInteractionEnabled:YES];
    [viewRS addSubview:viewNav];
    
    // ====== 导航栏左侧按钮 ======
    float x_btn = viewNav.bounds.origin.x;
    float y_btn = viewNav.bounds.origin.y;
    float h_btn = viewNav.bounds.size.height;
    float w_btn = h_btn;
    UIButton *btnLeft = [UIButton new];
    [btnLeft setFrame:CGRectMake(x_btn, y_btn, w_btn, h_btn)];
    [btnLeft setBackgroundColor:Color_Transparent];
    [btnLeft setAdjustsImageWhenHighlighted:NO];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTag:ViewTag_NavLeftBtn];
    [btnLeft addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnLeft];

    // ====== 导航栏右侧按钮 ======
    h_btn = viewNav.bounds.size.height;
    w_btn = h_btn;
    y_btn = viewNav.bounds.origin.y;
    x_btn = viewNav.bounds.size.width - w_btn;
    UIButton *btnRight = [UIButton new];
    [btnRight setFrame:CGRectMake(x_btn, y_btn, w_btn, h_btn)];
    [btnRight setBackgroundColor:Color_Transparent];
    [btnRight setAdjustsImageWhenHighlighted:NO];
    [btnRight setTitle:@"完成" forState:UIControlStateNormal];
    [btnRight setTag:ViewTag_NavRightBtn];
    [btnRight addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnRight];
    
    // ====== 导航栏标题 ======
    UIFont *fontTitle = Font_Text;
    UIColor *colorTitle = Color_Text;
    float x_child = (btnLeft == nil)? viewNav.bounds.origin.x : viewNav.bounds.origin.x + btnLeft.frame.size.width;
    float y_child = viewNav.bounds.origin.y;
    float w_child = (btnRight == nil)? viewNav.bounds.size.width - x_child*2 : btnRight.frame.origin.x - x_child;
    float h_child = viewNav.bounds.size.height - y_child;
    UILabel *labTitle = [UILabel new];
    [labTitle setFrame:CGRectMake(x_child, y_child, w_child, h_child)];
    [labTitle setBackgroundColor:Color_Transparent];
    [labTitle setText:@""];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    [labTitle setTextColor:colorTitle];
    [labTitle setFont:fontTitle];
    [labTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [labTitle setNumberOfLines:1];
    [viewNav addSubview:labTitle];
    
    return (id)viewRS;
}
/** 获取文件列表数据 */
- (void) getFileListData
{
    m_muDicFileList = [FileManager getAllFilesOfLocal];
    [self initTableCellView];
}
/** 初始化列表所有的CellView */
- (void) initTableCellView
{
    NSMutableDictionary *muDicCellView = [NSMutableDictionary new];
    NSArray *aryKeys = [m_muDicFileList allKeys];
    
    UIFont *fontName = Font_Text;
    UIFont *fontDecr = Font_Desc;
    UIColor *colorName = Color_Text;
    UIColor *colorDecr = Color_Decr;
    for(NSString *strKey in aryKeys)
    {
        NSArray *aryFileList = [m_muDicFileList objectForKey:strKey];
        for(FileItem *fileItem in aryFileList){
            FileItemView *itemView = [FileItemView new];
            [itemView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
            [itemView setName:[fileItem getFileName]];
            [itemView setNameFont:fontName];
            [itemView setNameTxColor:colorName];
            [itemView setDescription:[fileItem getFileSize]];
            [itemView setDescriptionFont:fontDecr];
            [itemView setDescriptionTxColor:colorDecr];
            [itemView setImg:[fileItem getImgIcon]];
            [itemView setFileItem:fileItem];
            [itemView initLayoutView];
            NSMutableArray *muAryCellView = [muDicCellView objectForKey:[fileItem getFileType]];
            if(muAryCellView == nil){
                muAryCellView = [NSMutableArray new];
                [muDicCellView setObject:muAryCellView forKey:[fileItem getFileType]];
            }
            [muAryCellView addObject:itemView];
        }
    }
    m_muDicCellView = muDicCellView;
}
/** 根据类型筛选对应的文件列表 */
- (void) showFileListWithFileTypes:(NSArray*)v_aryFileTypes
{
    NSMutableArray *muAryShow = [NSMutableArray new];
    if(v_aryFileTypes == nil
       || v_aryFileTypes.count == 0){
        v_aryFileTypes = [m_muDicCellView allKeys];
    }
    
    for(NSString *strKey in v_aryFileTypes){
        NSArray *aryCellView = [m_muDicCellView objectForKey:strKey];
        if(aryCellView != nil){
            [muAryShow addObjectsFromArray:aryCellView];
        }
    }
    m_aryShowList = muAryShow;
    UITableView *tvList = [self.view viewWithTag:ViewTag_TableView];
    [tvList reloadData];
}
/** 删除某一个文件项 */
- (void) deleteFileItem:(FileItem*)v_fileItem
{
    NSArray *aryKeys = [m_muDicFileList allKeys];
    for(NSString *strKey in aryKeys)
    {
        NSMutableArray<FileItem*> *muAry = [m_muDicFileList objectForKey:strKey];
        if([muAry containsObject:v_fileItem] == YES){
            [muAry removeObject:v_fileItem];
            // 删除本地文件
            [FileManager deleteFileWithPath:[v_fileItem getFilePath]];
            break;
        }
    }
}
/** 删除某一个文件项view */
- (void) deleteFileItemView:(FileItemView*)v_fileItemView
{
    [m_aryShowList removeObject:v_fileItemView];
    
    if(m_muArySelected != nil
       && [m_muArySelected containsObject:v_fileItemView] == YES){
        [m_muArySelected removeObject:v_fileItemView];
    }
    
    NSArray *aryKeys = [m_muDicCellView allKeys];
    for(NSString *strKey in aryKeys)
    {
        NSMutableArray<FileItemView*> *muAry = [m_muDicCellView objectForKey:strKey];
        if([muAry containsObject:v_fileItemView] == YES){
            [muAry removeObject:v_fileItemView];
            break;
        }
    }
}


/** 完成选择结果 */
- (void) commitSelected
{
    NSMutableArray<FileItem*> *muAryFileItem = [NSMutableArray<FileItem*> new];
    for(FileItemView *cellView in m_muArySelected){
        FileItem *itemObj = [cellView getFileItem];
        [muAryFileItem addObject:itemObj];
    }
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(getAllFilesOfSelected:)];
        if(bTemp == YES){
            [m_delegate getAllFilesOfSelected:muAryFileItem];
        }
    }
}
/** 关闭文件管理器 */
- (void) closeFileManagerViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ======================================================================================
#pragma mark 外部使用方法

// ======================================================================================
#pragma mark 动作触发方法
/** 点击按钮事件 */
- (void) clickBtn:(id)v_sender
{
    UIView *view = (UIView*)v_sender;
    switch((ViewTag)view.tag){
        case ViewTag_NavLeftBtn:{ // 顶部栏左按钮
            [self closeFileManagerViewController];
            break;
        }
        case ViewTag_NavRightBtn:{ // 顶部栏右按钮
            [self commitSelected];
            [self closeFileManagerViewController];
            break;
        }
        default:{ break; }
    }
}

// ======================================================================================
#pragma mark 委托协议UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return (m_aryShowList == nil)? 0 : m_aryShowList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTableCellViewID = @"FileManagerViewController";
    UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:strTableCellViewID];
    if(cellView == nil){
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableCellViewID];
        [cellView setBackgroundColor:Color_Transparent];
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    for(UIView *viewChild in [cellView.contentView subviews]){
        [viewChild removeFromSuperview];
    }
    UIView *view = [m_aryShowList objectAtIndex:indexPath.row];
    [cellView.contentView addSubview:view];

    return cellView;
}

// ======================================================================================
#pragma mark 委托协议UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [m_aryShowList objectAtIndex:indexPath.row];
    return view.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileItemView *itemView = [m_aryShowList objectAtIndex:indexPath.row];
    [itemView setIsSelected:![itemView getIsSelected]];
    
    if(m_muArySelected == nil){
        m_muArySelected = [NSMutableArray new];
    }
    if([itemView getIsSelected] == YES){
        [m_muArySelected addObject:itemView];
    
    } else {
        [m_muArySelected removeObject:itemView];
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){ // 删除
        FileItemView *itemView = [m_aryShowList objectAtIndex:indexPath.row];
        FileItem *fileItem = [itemView getFileItem];
        
        [self deleteFileItem:fileItem];
        [self deleteFileItemView:itemView];
        
        NSArray *aryDelete = @[ indexPath ];
        [tableView deleteRowsAtIndexPaths:aryDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

// ======================================================================================
#pragma mark 委托协议View_HorListDelegate
/** 选择文件选择栏的按钮 */
- (void) selectItem:(HorListItmObj*)v_item
{
    NSArray *aryFileType = nil;
    switch((ViewTag)[v_item getID]){
        case ViewTag_AllBtn:{ // 全部
            aryFileType = [FileManager getKeysWithAllType];
            break;
        }
        case ViewTag_DocBtn:{ // 文档
            aryFileType = [FileManager getKeysWithFile];
            break;
        }
        case ViewTag_ImgBtn:{ // 图片
            aryFileType = [FileManager getKeysWithImg];
            break;
        }
        default:{ break; }
    }
    [self showFileListWithFileTypes:aryFileType];
}

@end
