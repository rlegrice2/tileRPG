//
//  GameOverScene.m
//  TileRpg
//
//  Created by ownermac on 6/23/17.
//

#import "GameOverScene.h"
#import "HelloWorldScene.h"


@implementation GameOverScene
@synthesize layer = layer;

-(id)init {

	if ((self =[super init])) {
		self.layer = [GameOverLayer node];
		[self addChild:layer];
	}

		 return self;
}

- (void)dealloc {
	[layer release];
	layer = nil;
	[super dealloc];
}

@end


@implementation GameOverLayer
		   @synthesize label = label;

-(id) init

{		   
	if( (self=[super initWithColor:ccc4(225,225,225,225)] )){
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:42];
		 label.color = ccc3(0, 0, 0);
		 label.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:label];
		 
		 [self runAction:[CCSequence actions:
						 [CCDelayTime actionWithDuration:2],
						 [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
						  nil]];
	}
	return self;
		
}

-(void)gameOverDone {
 
	[[CCDirector sharedDirector] replaceScene:[HelloWorld scene]];

}
		 
- (void)dealloc {
	[label release];
	label = nil;
	[super dealloc];
}
	
@end
