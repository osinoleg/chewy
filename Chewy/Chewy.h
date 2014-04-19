//
//  Chewy.h
//  Chewy
//
//  Created by Oleg Osin on 4/15/14.
//  Copyright (c) 2014 Oleg Osin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CHEWY_ANIM { CHEWY_SPIN_ANIM = 0, CHEWY_TICKLE_ANIM };
    
@interface Chewy : NSObject

@property (nonatomic) UIImage* curFrame;

- (void)playAnim:(enum CHEWY_ANIM)anim;

@end
