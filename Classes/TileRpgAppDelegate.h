//
//  TileRpgAppDelegate.h
//  TileRpg
//
//  Created by ownermac on 6/23/17.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TileRpgAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
