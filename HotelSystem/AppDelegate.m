//
//  AppDelegate.m
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import "AppDelegate.h"

typedef enum : int{
    UIViewControllerTag_SelectDishStyleName = 1,
    UIViewControllerTag_NewDish , /* 新建、编辑菜界面 */
} UIViewControllerTag;

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    ViewController_selectDishTypeName   *m_viewControllerSelectDishStyleName;
    UINavigationController              *m_navigationController;
    ViewController_NewDishStyle         *m_viewControllerNewDishStyle;
    ViewController_DishStyle            *m_viewControllerDishStyle;
    ViewController_NewDish              *m_viewControllerNewDish;
    ViewController_DishList             *m_viewControllerDishList;
    BOOL                                m_bIsEditEnable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initData];
    ViewController_DeskManager *viewDeskManager = [ViewController_DeskManager new];
    [viewDeskManager setDelegate:(id)self];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewDeskManager];
    m_navigationController = navigationController;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:navigationController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lhj.HotelSystem" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotelSystem" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotelSystem.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
// ==================================================================================
#pragma mark - 内部使用方法
/** 初始化数据 */
- (void) initData
{
    m_bIsEditEnable = YES;
    [CPublic initCPublicObserver];
}
/** 打开已经选择的菜单界面 */
- (void) openViewControllerOfDishListOfSelected:(DeskItem*)v_deskItem
{
    ViewController_DishListOfSelected *viewController = [ViewController_DishListOfSelected new];
    [viewController setDelegate:(id)self];
    [viewController setDeskItem:v_deskItem];
    [m_navigationController pushViewController:viewController animated:YES];
}
// ==================================================================================
#pragma mark - 委托协议ViewController_DeskManagerDelegate
/** 打开该菜系选择界面 */
- (void) openDiskTypeView_deskItem:(DeskItem*)v_deskItem _sender:(id)v_sender
{
    ViewController_DishStyle *dishStyleViewController = [ViewController_DishStyle new];
    [dishStyleViewController setDelegate:(id)self];
    [dishStyleViewController setIsEditEnable:m_bIsEditEnable];
    [dishStyleViewController setDeskItem:v_deskItem];
    [m_navigationController pushViewController:dishStyleViewController animated:YES];
}
/** 设置是否开启编辑 */
- (void) setEditEnable:(BOOL)v_bIsEdit
{
    m_bIsEditEnable = v_bIsEdit;
}
/** 打开共享数据的界面 */
- (void) openShareDataViewController:(ViewController_DeskManager*)v_controller
{
    ViewController_ShareData *viewController = [ViewController_ShareData new];
    [viewController setDelegate:(id)self];
    [m_navigationController pushViewController:viewController animated:YES];
}

// ==================================================================================
#pragma mark - 委托协议ViewController_DishStyleDelegate
/** 打开新建菜系的界面 */
- (void) openViewControllerOfAddNewDishStyle_sender:(id)v_sender
{
    m_viewControllerDishStyle = v_sender;
    ViewController_NewDishStyle *viewController = [ViewController_NewDishStyle new];
    [viewController setDelegate:(id)self];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开编辑菜系的界面 */
- (void) openViewControllerOfEditDishStyle:(DishStyleItem*)v_dishStyleItem _sender:(id)v_sender
{
    m_viewControllerDishStyle = v_sender;
    ViewController_NewDishStyle *viewController = [ViewController_NewDishStyle new];
    [viewController setDelegate:(id)self];
    [viewController setDishStyleItemForEdit:v_dishStyleItem];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开推荐菜单 */
- (void) openViewControllerOfRecommendDish:(id)v_sender
{
    ViewController_DishStyle *controllerObj = v_sender;
    ViewController_DishList *viewController = [ViewController_DishList new];
    [viewController setIsOpenRecommendDish:YES];
    [viewController setDelegate:(id)self];
    [viewController setDeskItem:[controllerObj getDeskItem]];
    [viewController setIsEditEnable:m_bIsEditEnable];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开全部菜单 */
- (void) openViewControllerOfAllDish:(id)v_sender
{
    ViewController_DishStyle *controllerObj = v_sender;
    ViewController_DishList *viewController = [ViewController_DishList new];
    [viewController setIsOpenRecommendDish:NO];
    [viewController setDelegate:(id)self];
    [viewController setDeskItem:[controllerObj getDeskItem]];
    [viewController setIsEditEnable:m_bIsEditEnable];
    [m_navigationController pushViewController:viewController animated:YES];
}

/** 打开搜索菜单 */
- (void) openViewControllerOfSearchDishWithSearchText:(NSString*)v_strSearchText _sender:(id)v_sender
{
    ViewController_DishStyle *controllerObj = v_sender;
    ViewController_DishList *viewController = [ViewController_DishList new];
    [viewController setSearchText:v_strSearchText];
    [viewController setDelegate:(id)self];
    [viewController setDeskItem:[controllerObj getDeskItem]];
    [viewController setIsEditEnable:m_bIsEditEnable];
    [m_navigationController pushViewController:viewController animated:YES];
}

/** 打开指定菜系的菜单 */
- (void) openViewControllerOfDishListForDishStyleItem:(DishStyleItem*)v_dishStyleItem _sender:(id)v_sender
{
    ViewController_DishStyle *controllerObj = v_sender;
    ViewController_DishList *viewController = [ViewController_DishList new];
    [viewController setDishStyleIdOfDishList:[v_dishStyleItem getDishStyleID]
                              _dishStyleName:[v_dishStyleItem getDishStyleName]];
    [viewController setDelegate:(id)self];
    [viewController setIsEditEnable:m_bIsEditEnable];
    [viewController setDeskItem:[controllerObj getDeskItem]];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开该桌子已经选择的菜单界面 */
- (void) openViewControllerOfDishListOfSelectedFromDishStyleWithDeskItem:(DeskItem*)v_deskItem _sender:(id)v_sender
{
    [self openViewControllerOfDishListOfSelected:v_deskItem];
}

// ==================================================================================
#pragma mark - 委托协议ViewController_selectDishTypeNameDelegate
/** 编辑菜系名的界面 */
- (void) openViewControllerOfEditDishStyleName:(DishStyleNameItem*)v_strDishStyleName
{
    ViewController_EditText *editTextViewController = [ViewController_EditText new];
    [editTextViewController setDelegate:(id)self];
    [editTextViewController setNavTitle:@"编辑菜系名"];
    [editTextViewController setTextBegin:[v_strDishStyleName getDishStyleNameItemName]];
    [editTextViewController setTag:UIViewControllerTag_SelectDishStyleName];
    [editTextViewController setExtraObj:v_strDishStyleName];
    [m_navigationController pushViewController:editTextViewController animated:YES];
}

/** 添加菜系名的界面 */
- (void) openViewControllerOfAddDishStyleName
{
    ViewController_EditText *editTextViewController = [ViewController_EditText new];
    [editTextViewController setDelegate:(id)self];
    [editTextViewController setNavTitle:@"新建菜系名"];
    [editTextViewController setTag:UIViewControllerTag_SelectDishStyleName];
    [editTextViewController setExtraObj:nil];
    [m_navigationController pushViewController:editTextViewController animated:YES];
}
/** 返回选择的菜系名对象 */
- (void) getDishStyleNameItemOfSelectResult:(DishStyleNameItem*)v_dishStyleNameItem  _sender:(id)v_sender;
{
    ViewController_selectDishTypeName *viewController = v_sender;
    UIViewControllerTag tag = [viewController getTag];
    switch (tag) {
        case UIViewControllerTag_SelectDishStyleName:{
            [m_viewControllerNewDishStyle setNameOfDishStyleWithItem:v_dishStyleNameItem];
            break;
        }
        case UIViewControllerTag_NewDish:{
            [m_viewControllerNewDish setDishStyleWithID:[v_dishStyleNameItem getDishStyleNameItemID]
                                         _dishStyleName:[v_dishStyleNameItem getDishStyleNameItemName]];
            break;
        }
            
        default:{
            break;
        }
    }
}
// ==============================================================================================
#pragma mark -  委托协议ViewController_EditTextDelegate
/** 返回编辑的结果值 */
- (void) getEditTextResult:(NSString*)v_strResult _tag:(int)v_tag _sender:(id)v_sender
{
    UIViewControllerTag ControllerTag = v_tag;
    switch(ControllerTag){
        case UIViewControllerTag_SelectDishStyleName:{ // 添加、编辑菜系名
            DishStyleNameItem *item = [(ViewController_EditText*)v_sender getExtraObj];
            BOOL bRS = [self handleEditResultOfAddOrEditDishStyleName:v_strResult _dishStyleNameItem:item _viewController:v_sender];
            if(bRS == YES){
                [[(UIViewController*)v_sender navigationController] popViewControllerAnimated:YES];
            }
            
            break;
        }
        default:{
            break;
        }
    }
}
// ------------------------ 处理编辑框返回结果的方法 --------------------------------
/** 处理添加/编辑菜系名的编辑框结果 */
- (BOOL) handleEditResultOfAddOrEditDishStyleName:(NSString*)v_strResult
                               _dishStyleNameItem:(DishStyleNameItem*)v_dishStyleNameItem
                                  _viewController:(UIViewController*)v_viewController;
{
    BOOL bRS = YES;
    if(v_dishStyleNameItem != nil){ // 编辑菜系名
        [v_dishStyleNameItem setDishStyleNameItemName:v_strResult];
        bRS = [m_viewControllerSelectDishStyleName updateDishStyleNameItem:v_dishStyleNameItem];
        if(bRS == YES){
            [CPublic ShowToastWithAndroid:@"编辑成功"];
        }
    
    } else { // 添加新的菜系名
        bRS = [m_viewControllerSelectDishStyleName addDishStyleNameItem:v_strResult];
        if(bRS == YES){
            [CPublic ShowToastWithAndroid:@"添加成功"];
        } else {
//            [CPublic ShowToastWithAndroid:@"添加失败，该菜系名已存在"];
            [CPublic ShowDialgController:@"添加失败，该菜系名已存在" _viewController:v_viewController];
        }
    }
    return bRS;
}
// ==================================================================================
#pragma mark - 委托协议ViewController_NewDishStyleDelegate
/** 打开选择菜系名的下拉选择列表界面 */
- (void) openSelectDropView:(id)v_sender
{
    m_viewControllerNewDishStyle = v_sender;
    ViewController_selectDishTypeName *selectDishStyleNameViewController = [ViewController_selectDishTypeName new];
    [selectDishStyleNameViewController setDelegate:(id)self];
    [selectDishStyleNameViewController setTag:UIViewControllerTag_SelectDishStyleName];
    [m_navigationController pushViewController:selectDishStyleNameViewController animated:YES];
    m_viewControllerSelectDishStyleName = selectDishStyleNameViewController;
}
/** 确定新建菜系 */
- (void) commitAddNewDishStyleWithID:(NSString*)v_strDishStyleID
                               _name:(NSString*)v_strName
                       _iconFilePath:(NSString*)v_strIconFilePath;
{
    if(m_viewControllerDishStyle != nil){
        [m_viewControllerDishStyle addDishStyleWithDishStyleID:v_strDishStyleID
                                                         _name:v_strName
                                                  _imgFilePath:v_strIconFilePath];
    }
}
/** 确定编辑菜系 */
- (void) commitEditDishStyleWithDishStyleID:(NSString*)v_strID
                                   _newName:(NSString*)v_strName
                           _newIconFilePath:(NSString*)v_strIconFilePath
{
    if(m_viewControllerDishStyle != nil){
        [m_viewControllerDishStyle editDishStyleWithDishStyleID:v_strID _newName:v_strName _newImgFilePath:v_strIconFilePath];
    }
}
// ==================================================================================
#pragma mark - 委托协议ViewController_DishListDelegate
/** 打开添加菜的页面 */
- (void) openNewDishViewController_dishStyleID:(NSString*)v_strDishStyleID
                                _dishStyleName:(NSString*)v_strDishStyleName
                                  _isRecommend:(BOOL)v_bIsRecommend
                                       _sender:(id)v_sender
{
    m_viewControllerDishList = v_sender;
    ViewController_NewDish *viewController = [ViewController_NewDish new];
    [viewController setDelegate:(id)self];
    [viewController setIsRecommendDefault:v_bIsRecommend];
    [viewController setDishStyleWithID:v_strDishStyleID _dishStyleName:v_strDishStyleName];
    [viewController setTag:UIViewControllerTag_NewDish];
    [m_navigationController pushViewController:viewController animated:YES];
}

/** 打开编辑菜的页面 */
- (void) openEditDishViewControllerWithDishItem:(DishItem*)v_dishItem _sender:(id)v_sender
{
    m_viewControllerDishList = v_sender;
    ViewController_NewDish *viewController = [ViewController_NewDish new];
    [viewController setDelegate:(id)self];
    [viewController setDishItemForEdit:v_dishItem];
    [viewController setTag:UIViewControllerTag_NewDish];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开菜浏览的页面 */
- (void) openDishDetailsViewControllerWithDishList:(NSArray<DishItem*>*)v_aryDishList
                                         _aryIndex:(int)v_index
                                           _sender:(id)v_sender
{
    ViewController_DishList *controllerObj = v_sender;
    ViewController_DishDetails *viewController = [ViewController_DishDetails new];
    [viewController setDishItemList:v_aryDishList _curIndex:v_index];
    [viewController setDelegate:(id)self];
    [viewController setDeskItem:[controllerObj getDeskItem]];
    [m_navigationController pushViewController:viewController animated:YES];
}
/** 打开该桌子已经选择的菜单界面 */
- (void) openViewControllerOfDishListOfSelectedFromDishListWithDeskItem:(DeskItem*)v_deskItem
                                                                _sender:(id)v_sender
{
    [self openViewControllerOfDishListOfSelected:v_deskItem];
}
// ==================================================================================
#pragma mark - 委托协议ViewController_NewDishDelegate
/** 打开选择菜系名的下拉选择列表界面 */
- (void) openSelectDropView_newDish:(id)v_sender
{
    m_viewControllerNewDish = v_sender;
    ViewController_selectDishTypeName *viewController = [ViewController_selectDishTypeName new];
    [viewController setDelegate:(id)self];
    [viewController setTag:UIViewControllerTag_NewDish];
    [m_navigationController pushViewController:viewController animated:YES];
    m_viewControllerSelectDishStyleName = viewController;
}
/** 新建菜，返回一个没有ID的DishItem，ID在添加数据库的时候自动创建 */
- (void) addNewDishWithDishItemOfNoID:(DishItem*)v_dishItem
{
    [m_viewControllerDishList addNewDish:v_dishItem];
}

/** 新建菜，返回一个更新数据之后的DishItem */
- (void) updateDishWithDishItem:(DishItem*)v_dishItem
{
    [m_viewControllerDishList updateDish:v_dishItem];
}
// ==================================================================================
#pragma mark - 委托协议ViewController_DishListOfSelectedDelegate
/** 再去选菜，打开选择菜系的界面 */
- (void) openViewControllerOfDishStyleFromDishListSelectedView_deskItem:(DeskItem*)v_deskItem
                                                                _sender:(id)v_sender
{
    NSArray *aryChild = [m_navigationController childViewControllers];
    ViewController_DishStyle *dishStyleViewController = nil;
    for(UIViewController *viewController in aryChild){
        if([viewController isKindOfClass:[ViewController_DishStyle class]] == YES){
            dishStyleViewController = (ViewController_DishStyle*)viewController;
            break;
        }
    }
    if(dishStyleViewController == nil){
        dishStyleViewController = [ViewController_DishStyle new];
        [dishStyleViewController setDelegate:(id)self];
        [dishStyleViewController setIsEditEnable:m_bIsEditEnable];
        [dishStyleViewController setDeskItem:v_deskItem];
        [m_navigationController pushViewController:dishStyleViewController animated:YES];
    } else {
        [dishStyleViewController setDelegate:(id)self];
        [dishStyleViewController setIsEditEnable:m_bIsEditEnable];
        [dishStyleViewController setDeskItem:v_deskItem];
        [m_navigationController popToViewController:dishStyleViewController animated:YES];
    }
    
}
// ==================================================================================
#pragma mark - 委托协议ViewController_DishDetailsDelegate

@end
