//
//  HelloWorldLayer.m
//  TileRpg
//
//  Created by ownermac on 6/23/17.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"



@implementation HelloWorldHud
@synthesize gameLayer = gameLayer;

//HUD layer score counter
-(id) init
{
    if ((self = [super init])) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		label = [CCLabelTTF labelWithString:@"score 0" dimensions:CGSizeMake(100, 20)
								  alignment:UITextAlignmentRight fontName :@"Verdana-Bold"
								   fontSize:14.0];
		label.color = ccc3(0,0, 0);
		int margin = 10;
		label.position = ccp(winSize.width - (label.contentSize.width/2)					 
							 - margin, label.contentSize.height/2 + margin);
		[self addChild:label];
		CCSprite * background = [CCSprite spriteWithFile:@"labelbackground.png"];
		background.position = ccp(winSize.width - (background.contentSize.width/2)					 
								  - 6, background.contentSize.height/2 + 12);
		//[background setPosition:ccp(160,255)];
		[self addChild:background z:-1];
		 
		
// define the projectile button 
		CCMenuItem *on;
		CCMenuItem *off;
		
		on = [[CCMenuItemImage itemFromNormalImage:@"projectile-button-on.png"
									 selectedImage:@"projectile-button-on.png" target:nil selector:nil] retain];
		off = [[CCMenuItemImage itemFromNormalImage:@"projectile-button-off.png"
									  selectedImage:@"projectile-button-off.png" target:nil selector:nil] retain];
		
		
		CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self
															   selector:@selector(projectileButtonTapped:) items:off, on, nil];
		CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
		toggleMenu.position = ccp(100,32);
		[self addChild:toggleMenu];
		
	}
	return self;
}

-(void)projectileButtonTapped:(id)sender
{
	
	if (gameLayer.mode == 1){
		gameLayer.mode = 0;
	} else {
		gameLayer.mode = 1;
	}
	
}


- (void) numberCollectedChanged:(int)numCollected {
	    [label setString:[NSString stringWithFormat:@"score %d", numCollected]];
	
}
@end

// HelloWorld implementation
@implementation HelloWorld
@synthesize tiledMap = tiledMap;
@synthesize Background = Background; 
@synthesize gameman = gameman;
@synthesize BumpLayer = BumpLayer;
@synthesize Top = Top;
@synthesize Items = Items;
@synthesize numCollected = numCollected;
@synthesize hud = hud;
@synthesize mode = mode;
@synthesize labelbackground = labelbackground;
@synthesize bug = bug;
@synthesize walkAction = walkAction;


+(id) scene
{
// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
// add layer as a child to scene
	[scene addChild: layer];
	
//Add Hud scene layer
	HelloWorldHud *hud = [HelloWorldHud node];
	[scene addChild:hud];
	
	layer.hud = hud;
	hud.gameLayer = layer;
	
	
// return the scene
	return scene;
}
//*****Hello world class******

// above method is set, position of "gameman" is CGPoint, 
//Now CAMERA set up
// The size of the camera is the size of the iphone screen
-(void) setCenterOfScreen:(CGPoint) position{
	CGSize screenSize = [[CCDirector sharedDirector]winSize];
	
	//half of height =160 half of width =240
	//this finds the max position of where the start point can be.
	int x = MAX(position.x, screenSize.width/2);
	int y = MAX(position.y, screenSize.height/2);
	
	//this finds the min position of where the start point can be.
	x = MIN(x, tiledMap.mapSize.width * tiledMap.tileSize.width - screenSize.width/2);
	y = MIN(y, tiledMap.mapSize.height * tiledMap.tileSize.height - screenSize.height/2);
	CGPoint goodPoint = ccp(x,y);
	//here we are moving the background layer/background image around instead of the camera
	CGPoint centerOfScreen = ccp(screenSize.width/2, screenSize.height/2);
	CGPoint difference = ccpSub(centerOfScreen, goodPoint);
	self.position = difference;
	
}
// a method to move the enemy 10 pixels toward the player
-(void) animateEnemy:(CCSprite*)enemy
{
	
	//speed of the enemy
	int minDuration = 0.95;
	int maxDuration = 2.0;
	int rangeDuration = maxDuration - minDuration;
	ccTime actualDuration = (arc4random() % rangeDuration) + minDuration;
	//ccTime actualDuration = (arc4random() % 20)/10.0;
	
	
//Create the actions
	id actionMove = [CCMoveBy actionWithDuration:actualDuration
										position:ccpMult(ccpNormalize(ccpSub(gameman.position, enemy.position)), 10)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self
											 selector:@selector(enemyMovefinished:)];
	[enemy runAction:[CCSequence actions:actionMove,actionMoveDone,  nil]];
	
}									 


// callback. starts another iteration of enemy movement.
-(void) enemyMovefinished:(id)sender {
	CCSprite *enemy = (CCSprite *)sender;
	CGPoint diff = ccpSub(gameman.position,enemy.position);

	if (diff.x < 0) {
		enemy.flipX = NO;
	} else {
		enemy.flipX = YES;
	} 
	
	[self animateEnemy: enemy];
}



//Add enemy class
-(void)addEnemyAtX:(int)x y:(int)y {
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bug.plist"];
	CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bug.png"];
	[self addChild:spriteSheet];
	
//Loop thru frames and add a cache of the frames  
	NSMutableArray *walkAnimFrames =[NSMutableArray array];
	for (int i = 1; i <= 20; ++i) {
		[walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
								   [NSString stringWithFormat:@"bug%d.png", i]]];
		
	}
		
	CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.05f];
	
	CCSprite *enemy = [CCSprite spriteWithFile:@"bug.png"];
	enemy.position = ccp(x, y);
	  walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
	[enemy runAction:walkAction];
	[self addChild:enemy];
	[enemies addObject:enemy];
	[self animateEnemy:enemy];
	
}
//Game over - win or lose scene
-(void)lose {
	
	[self runAction:[CCSequence actions:
					 [CCDelayTime actionWithDuration:1],
					 [CCCallFunc actionWithTarget:self selector:@selector(switchToGameOverScene)],
					 nil]];
}

-(void)switchToGameOverScene

{
	
	GameOverScene *gameOverScene = [GameOverScene node];
	[gameOverScene.layer.label setString:@"You Lose!"];
	[[SimpleAudioEngine sharedEngine] playEffect:@"lose.caf"];
	[[CCDirector sharedDirector] replaceScene:gameOverScene];
	
	
	
}
-(void)win {
	
	//GameOverScene *gameOverScene = [GameOverScene node];
	//[gameOverScene.layer.label setString:@"You Win"];
	
	[self runAction:[CCSequence actions:
					 [CCDelayTime actionWithDuration:1],
					 [CCCallFunc actionWithTarget:self selector:@selector(switchToGameOverScene1)],
					 nil]];
}

-(void)switchToGameOverScene1
{
	
	GameOverScene *gameOverScene = [GameOverScene node];
	[gameOverScene.layer.label setString:@"You Win"];
	[[SimpleAudioEngine sharedEngine] playEffect:@"win.caf"];
	[[CCDirector sharedDirector] replaceScene:gameOverScene];
	
	
}
-(void)testCollisions:(ccTime)dt{
	for (CCSprite *target in enemies) {
		CGRect targetRect = CGRectMake(
									   target.position.x - (target.contentSize.width/2),
									   target.position.y - (target.contentSize.width/2),
									   target.contentSize.width,
									   target.contentSize.height);
	if (CGRectContainsPoint(targetRect, gameman.position)) {
    [self lose];
		}
	}
	
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc]init];
//Iterate through projectiles
	for (CCSprite *projectile in projectiles) {
		CGRect projectileRect = CGRectMake(
										   projectile.position.x - (projectile.contentSize.width/2),
										   projectile.position.y - (projectile.contentSize.width/2),
										   projectile.contentSize.width,
										   projectile.contentSize.height);
		
		NSMutableArray * targetsToDelete = [[NSMutableArray alloc] init];
		
//Iterate through enemies, see if any intersect with current projectile
		for (CCSprite *target in enemies) {
			CGRect targetRect = CGRectMake(
										   target.position.x - (target.contentSize.width/2),
										   target.position.y - (target.contentSize.width/2),
										   target.contentSize.width,
										   target.contentSize.height);
			
			
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
				[targetsToDelete addObject:target];
			}
		}
//delete all hit enemies
		for (CCSprite *target in targetsToDelete) {
			[enemies removeObject:target];
			[self removeChild:target cleanup:YES];
			
//New added explosion effect!!!!!	
			CCParticleFire* explosion = [[CCParticleFire alloc] initWithTotalParticles:200];
			explosion.autoRemoveOnFinish = YES;
			explosion.startSize = 20.0f;
			explosion.speed = 5.0f;
			explosion.radialAccel = -10;
			explosion.radialAccelVar = 0;
			explosion.life = 1;
			explosion.lifeVar = 1;
			explosion.anchorPoint = ccp(0.5f,0.5f);
			explosion.position = target.position;
			explosion.duration = 0.50f;
			[self addChild:explosion z:12];
			[explosion release];
		}
		
		if (targetsToDelete.count > 0) {
			//add the projectile to the list of ones to delete
			[projectilesToDelete addObject:projectile];
		}
		[targetsToDelete release];
	}
	
//remove all the projectiles that hit.
	for (CCSprite *projectile in projectilesToDelete) {
		[projectiles  removeObject:projectile];
		[[SimpleAudioEngine sharedEngine] playEffect:@"destroy.caf"];
		[self removeChild:projectile cleanup:YES];	
	}
	
	[projectilesToDelete release];
}								   

-(id) init
{

	if((self=[super init] )) {
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"fire.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"destroy.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"win.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"lose.caf"];
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TileMap.caf"];
		
		
		
		self.isTouchEnabled = YES;
		
		self.tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TiledRPG.tmx"];
		self.Background = [tiledMap layerNamed:@"Background"];
		self.Items = [tiledMap layerNamed:@"Items"];
		self.BumpLayer = [tiledMap layerNamed:@"BumpLayer"];
		self.Top = [tiledMap layerNamed:@"Top"];
		BumpLayer.visible = NO;
		mode = 0;
		
		//first line retrieves the object layer
		//second line retrieves the "object" layer start point and it's co-ordinates
		CCTMXObjectGroup *objects = [tiledMap objectGroupNamed:@"Obj"];
		NSMutableDictionary *startPoint = [objects objectNamed:@"startPoint"];
		int x = [[startPoint valueForKey:@"x"] intValue];
		int y = [[startPoint valueForKey:@"y"] intValue];
		
		//then take the x and y co-ordinates and postioned the sprite were the 
		//start point is
		self.gameman = [CCSprite spriteWithFile:@"gameMan.png"];
		gameman.position = ccp(x,y);
		[self addChild:gameman];
		//this method is declared here
		[self setCenterOfScreen:gameman.position];
		
		[self addChild:tiledMap z:-1];
		
		// in the init method - after creating the player
		// iterate through objects, finding all enemy spawn points
		// create an enemy for each one
		NSMutableDictionary * spawnPoint;
		
		enemies = [[NSMutableArray alloc]init];
		projectiles = [[NSMutableArray alloc]init];
		for (spawnPoint in [objects objects]) {
			if ([[spawnPoint valueForKey:@"Enemy"]intValue]== 1) {
				x = [[spawnPoint valueForKey:@"x"] intValue];
				y = [[spawnPoint valueForKey:@"y"] intValue];
				[self addEnemyAtX: x y:y];
			}
		}
		[self schedule:@selector(testCollisions:)];
	}
	return self;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
	int x = position.x / tiledMap.tileSize.width;
	int y = ((tiledMap.mapSize.height * tiledMap.tileSize.height) - position.y) / tiledMap.tileSize.height;
	return ccp(x, y);
}
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}



-(void)setPlayerPosition:(CGPoint)position{
	CGPoint tileCoord = [self tileCoordForPosition:position];
	
	
	int tileGid = [BumpLayer tileGIDAt:tileCoord];
	if (tileGid){
		NSDictionary *properties = [tiledMap propertiesForGID:tileGid];
		if (properties) {
			NSString *collision = [properties valueForKey:@"Collidable"];
			if (collision && [collision compare:@"True"] ==NSOrderedSame) {
				[[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
				return;
			}
			//Makes the item marked by the bumplayer tile, return the "Collectable" value		
			NSString *collectable = [properties valueForKey:@"Collectable"];
			if (collectable && [collectable compare:@"True"] == NSOrderedSame) {
				[BumpLayer removeTileAt:tileCoord];
				[Items removeTileAt:tileCoord];
				
				//in the case where a tile is collectable
				self.numCollected++;
				[hud numberCollectedChanged:numCollected];
				[[SimpleAudioEngine sharedEngine] playEffect:@"pickup.caf"];
				// put the number of melons on your map in place of the '2'
				if (numCollected == 3) {
					[self win]; 
				}
			}
		}
	}	
	[[SimpleAudioEngine sharedEngine] playEffect:@"move.caf"];
	gameman.position = position;
}
-(void) projectileMoveFinished: (id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	[projectiles removeObject:sprite];
	
	
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event

{
	if (mode == 0) {
		CGPoint touchLocation = [touch locationInView: [touch view]];
		touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
		touchLocation = [self convertToNodeSpace:touchLocation];
		
		CGPoint playerPos = gameman.position;
		CGPoint diff = ccpSub(touchLocation, playerPos);
		
//move horizontally or vertical
		if (abs(diff.x) > abs(diff.y)) {
			if (diff.x > 0) {
				playerPos.x += tiledMap.tileSize.width;
			} else {
				playerPos.x -= tiledMap.tileSize.width;
			}
		} else {		
			if (diff.y > 0) {
				playerPos.y += tiledMap.tileSize.height;
			} else {
				playerPos.y -= tiledMap.tileSize.height;
			}
//change gameman orientation walking
			if (diff.x > 0) {
				gameman.flipX = NO;
			} else {
				gameman.flipX = YES;
			} 
		}	
//make sure the player doesn't go off the map
		if (playerPos.x <= (tiledMap.mapSize.width * tiledMap.tileSize.width) &&
			playerPos.y <= (tiledMap.mapSize.height * tiledMap.tileSize.height) &&
			playerPos.y >= 0 &&
			playerPos.x >= 0)
			
		{
			[self setPlayerPosition:playerPos];
		}
		[self setCenterOfScreen:gameman.position];
		
	} else {
		CGPoint touchLocation = [touch locationInView: [touch view]];
		touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
		touchLocation = [self convertToNodeSpace:touchLocation];
		
		// Create a projectile and put it at the player's location
		CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png"];
		[[SimpleAudioEngine sharedEngine] playEffect:@"fire.caf"];
		projectile.position = gameman.position;
		[self addChild:projectile];
		
// Determine where we wish to shoot the projectile to
		int realX;
		
// Are we shooting to the left or right?
		CGPoint diff = ccpSub(touchLocation, gameman.position);
		if (diff.x > 0) {
			realX = (tiledMap.mapSize.width * tiledMap.tileSize.width) + (projectile.contentSize.width/2);
		}else {
			realX = -(tiledMap.mapSize.width * tiledMap.tileSize.width) - (projectile.contentSize.width/2);
		}
		float ratio = (float) diff.y / (float) diff.x;
		int realY = ((realX - projectile.position.x) * ratio) + projectile.position.y;
		CGPoint realDest = ccp(realX, realY);
		
//Determime the length of how far we are shooting
		int offRealX = realX - projectile.position.x;
		int offRealY = realY - projectile.position.y;
		float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
		float velocity = 480/1.5; //480pixels/1sec
		float realMoveDuration = length/velocity;
		
//Move the projectile to actual end point
		id actionMoveDone = [CCCallFuncN actionWithTarget:self
												 selector:@selector(projectileMoveFinished:)];
		[projectile runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:realMoveDuration
																		position:realDest]
																		two:actionMoveDone]];
		
																		[projectiles addObject:projectile];
		
	}

}


- (void) dealloc
{
	self.tiledMap = nil;
	self.Background = nil;
	self.gameman = nil;
	self.BumpLayer = nil;
	self.Items = nil;
	self.hud = nil;
	self.bug = nil;
	self.walkAction = nil;
		
	
	
	[super dealloc];
}
@end
