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
}

- (id)init
{
    if(self = [super init])
    {
        _defaultFrame = [UIImage imageNamed:@"chewy1_0"];

        
        return self;
    }
    
    return self;
}

@end
