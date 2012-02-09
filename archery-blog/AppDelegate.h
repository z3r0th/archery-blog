//
//  AppDelegate.h
//  archery-blog
//
//  Created by Matheus Teixeira Fernandes on 08/02/12.
//  Copyright UFSC 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
