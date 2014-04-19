//
//  Chewy.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "Chewy.h"

#define CHEWY_SCALE 0.2f

@implementation Chewy {
    UIImage* _defaultFrame;
    NSArray* _spinAnim;
    NSTimer* _animTimer;
    enum CHEWY_ANIM _curAnim;
    int _curFrameIndex;
}

- (id)init
{
    if(self = [super init])
    {
        _defaultFrame = [UIImage imageNamed:@"chewy1_0"];
        _curFrame = _defaultFrame;
        _curFrameIndex = 0;
        
        _spinAnim = @[[UIImage imageNamed:@"chewy1_0"], [UIImage imageNamed:@"chewy1_1"],
                      [UIImage imageNamed:@"chewy1_2"], [UIImage imageNamed:@"chewy1_3"]];
        
        return self;
    }
    
    return self;
}

- (void)playAnim:(enum CHEWY_ANIM)anim
{
    if([_animTimer isValid] == YES)
        return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChewyAnimationBeganNotification" object:self];
    
    _animTimer = [NSTimer scheduledTimerWithTimeInterval:0.08
                                     target:self
                                   selector:@selector(updateAnimation:)
                                   userInfo:nil
                                    repeats:YES];
    
    _curAnim = anim;
    _curFrameIndex = 0;
    
    if(anim == CHEWY_SPIN_ANIM)
    {
        [self updateAnimation:_animTimer];
    }
    else
    {
    
    }
}

- (void)updateAnimation:(NSTimer*)timer
{

    if(_curAnim == CHEWY_SPIN_ANIM)
    {
        if(_curFrameIndex >= [_spinAnim count])
        {
            [self endAnimation];
        }
        
        _curFrame = [_spinAnim objectAtIndex:_curFrameIndex];
        _curFrameIndex++;
    }
    else
    {
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChewyAnimationUpdatedNotification" object:self];
}

- (void)endAnimation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChewyAnimationEndedNotification" object:self];
    [_animTimer invalidate];
    _curFrameIndex = 0;
}

@end
