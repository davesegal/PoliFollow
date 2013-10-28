//
//  Representative+PLFDataHelper.h
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "Representative.h"

@interface Representative (PLFDataHelper)

FOUNDATION_EXTERN NSString *const PLFRepresentiveFederalSen;
FOUNDATION_EXTERN NSString *const PLFRepresentiveFederalRep;
FOUNDATION_EXTERN NSString *const PLFRepresentiveStateRep;

- (void)populateRepCategory;


@end
