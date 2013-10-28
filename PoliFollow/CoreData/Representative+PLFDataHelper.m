//
//  Representative+PLFDataHelper.m
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "Representative+PLFDataHelper.h"


NSString *const PLFRepresentiveFederalSen = @"US Senate";
NSString *const PLFRepresentiveFederalRep = @"US House of Reps";
NSString *const PLFRepresentiveStateRep = @"State Rep";

@implementation Representative (PLFDataHelper)

- (void)populateRepCategory
{
    if ([self.chamber isEqualToString:@"senate"])
    {
        self.category = PLFRepresentiveFederalSen;
    }
    else if ([self.chamber isEqualToString:@"house"])
    {
        self.category = PLFRepresentiveFederalRep;
    }
    else
    {
        self.category = @"";
    }
}

@end
