//
//  Representative+PLFDataHelper.h
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "Representative.h"

typedef NS_OPTIONS(NSInteger, PLFRepresentativeType)
{
    PLFRepresentativeTypeFederalRep = 1 << 0,
    PLFRepresentativeTypeFederalSenate = 1 << 1,
    PLFRepresentativeTypeFederalHouse = 1 << 2,
    PLFRepresentativeTypeStateRep = 1 << 3,
    PLFRepresentativeTypeUnknown = 1 << 4
};

@interface Representative (PLFDataHelper)

//FOUNDATION_EXTERN NSString *const PLFRepresentativeFederalSen;
//FOUNDATION_EXTERN NSString *const PLFRepresentativeFederalRep;
//FOUNDATION_EXTERN NSString *const PLFRepresentativeStateRep;


- (void)deserializeData:(NSDictionary *)repData ofRepType:(NSInteger)repType;

@end
