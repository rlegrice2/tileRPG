//
//  HelloWorldLayer.h
//  TileRpg
//
//  Created by ownermac on 6/23/17.




#import "cocos2d.h"
@class HelloWorld;
@interface HelloWorldHud : CCLayer
{
	
	CCLabelTTF *label;
	HelloWorld *gameLayer;
	CCSprite *labelbackground;
}

@property (nonatomic, retain) HelloWorld *gameLayer;

-(void)numberCollectedChanged:(int)numCollected;
@end

// HelloWorld Layer
@interface HelloWorld : CCLayer

{
	CCAction *walkAction;
	CCSprite *bug;
	CCTMXTiledMap *tiledMap;
	CCTMXLayer *Background;
	CCSprite *gameman;
	CCTMXLayer *BumpLayer;
	CCTMXLayer *Top;
	CCTMXLayer *Items;
	int numCollected;
	HelloWorldHud *hud;
	int mode;
	NSMutableArray *enemies;
	NSMutableArray *projectiles;
	
	
}

@property (nonatomic, retain) CCTMXTiledMap *tiledMap;
@property (nonatomic, retain) CCTMXLayer *Background;
@property (nonatomic, retain) CCSprite *gameman;
@property (nonatomic, retain) CCSprite *bug;
@property (nonatomic, retain) CCSprite *labelbackground;
@property (nonatomic, retain) CCTMXLayer *BumpLayer;
@property (nonatomic, retain) CCTMXLayer *Top;
@property (nonatomic, retain) CCTMXLayer *Items;
@property (nonatomic, assign) int numCollected;
@property (nonatomic, assign) int mode;
@property (nonatomic, retain) HelloWorldHud *hud;
@property (nonatomic, retain) CCAction *walkAction;






+(id) scene;
-(void) setPlayerPosition:(CGPoint)position;
-(void) setCenterOfScreen:(CGPoint) position;




@end
