//
//  AppDelegate.h
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

