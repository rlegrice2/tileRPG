//
//  StartMenu.m
//  TileRpg
//
//  Created by ownermac on 6/23/17.
//





#import "HelloWorldScene.h"
#import "StartMenu.h"

CCSprite *player;

// StartMenu implementation
@implementation StartMenu

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [StartMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{

	if( (self=[super init] )) {
		
		CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage:@"start.png"  selectedImage:@"start.png" 								
															  target:self
															selector:@selector(doThis:)];
		CCMenu *menu =[CCMenu menuWithItems:item, nil];
		
		[self addChild:menu];
		
	}	
	return self;
}

-(void)doThis:(id)sender{
	//[[CCDirector sharedDirector]replaceScene: [TransitionScene scene]];
	[[CCDirector sharedDirector]replaceScene:[HelloWorld scene]];
	
}	

- (void) dealloc
{

	[super dealloc];
}
@end


