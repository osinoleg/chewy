//
//  ChewyView.m
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import "ChewyView.h"

#define MAX_VISIBLE_MSGS 3

@implementation ChewyView {
    UIImageView* _chewy;
    Chewy* _chewyAnimModel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleChewyAnimation:)
                                                     name:@"ChewyAnimationBeganNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleChewyAnimation:)
                                                     name:@"ChewyAnimationUpdatedNotification"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleChewyAnimation:)
                                                     name:@"ChewyAnimationEndedNotification"
                                                   object:nil];
        
        _chewy = [[UIImageView alloc] initWithImage:_chewyAnimModel.curFrame];
        _chewy.contentMode = UIViewContentModeScaleAspectFit;
        _chewy.frame = CGRectMake(0, 0, 80, 133);
        [self addSubview:_chewy];

    }
    return self;
}

- (id)initWithData:(Chewy*)chewy frame:(CGRect)frame
{    
    _chewyAnimModel = chewy;
    return [self initWithFrame:frame];
}

- (void)handleChewyAnimation:(NSNotification*)notification
{
    if([[notification name] isEqualToString:@"ChewyAnimationBeganNotification"])
    {
        //
    }
    else if([[notification name] isEqualToString:@"ChewyAnimationUpdatedNotification"])
    {
        _chewy.image = _chewyAnimModel.curFrame;
    }
    else if([[notification name] isEqualToString:@"ChewyAnimationEndedNotification"])
    {
        _chewy.image = _chewyAnimModel.curFrame;
    }
}

@end
