//
//  AppDelegate.h
//  HotelSystem
//
//  Created by hancj on 15/11/13.
//  Copyright © 2015年 hancj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController_DeskManager.h"
#import "ViewController_DishStyle.h"
#import "ViewController_NewDishStyle.h"
#import "ViewController_selectDishTypeName.h"
#import "ViewController_EditText.h"
#import "ViewController_DishList.h"
#import "ViewController_NewDish.h"
#import "ViewController_DishDetails.h"
#import "ViewController_DishListOfSelected.h"
#import "ViewController_ShareData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ViewController_DeskManagerDelegate,ViewController_DishStyleDelegate, ViewController_NewDishStyleDelegate, ViewController_selectDishTypeNameDelegate, ViewController_EditTextDelegate, ViewController_DishListDelegate, ViewController_NewDishDelegate, ViewController_DishDetailsDelegate, ViewController_DishListOfSelectedDelegate, ViewController_ShareDataDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

