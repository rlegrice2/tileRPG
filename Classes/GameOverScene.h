//
//  GameOverScene.h
//  TileRpg
//
//  Created by ownermac on 6/23/17.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameOverLayer : CCLayerColor {
	CCLabelTTF *label;
}

@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
	GameOverLayer *layer;
}
@property (nonatomic, retain) GameOverLayer *layer; 
@end
