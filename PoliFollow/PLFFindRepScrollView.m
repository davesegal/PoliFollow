//
//  PLFFindRepScrollView.m
//  PoliFollow
//
//  Created by David Segal on 11/1/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFFindRepScrollView.h"

@implementation PLFFindRepScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setContentOffset:(CGPoint)contentOffset
{
    
    [super setContentOffset:contentOffset];
}

-(void) setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:contentOffset animated:animated];
}

@end
