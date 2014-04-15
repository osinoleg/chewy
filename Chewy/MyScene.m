//
//  MyScene.m
//  Chewy
//
//  Created by Oleg Osin on 4/14/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    SKSpriteNode* _chewySprite;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        _chewySprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        _chewySprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
        [_chewySprite setScale:0.2f];
        [self addChild:_chewySprite];
        
        SKLabelNode *myLabel = [[SKLabelNode alloc] init];
        myLabel.text = @"<insert push notification msg here>";
        myLabel.fontSize = 14;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) - _chewySprite.frame.size.height + 10);
        
        [self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    return;
    for (UITouch *touch in touches) {
        // check if _chewy was touched
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
