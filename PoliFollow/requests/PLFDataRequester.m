//
//  PLFDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/11/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFDataRequester.h"
#import "Representative.h"


//http://whoismyrepresentative.com/getall_mems.php?zip=10009

NSString * const MICRO_DATA_URL = @"www.govtrack.us/api/v2/role";
NSString * const MACRO_DATA_URL = @"whoismyrepresentative.com/getall_mems.php";

@implementation PLFDataRequester

+ (id) getDataByZipCode:(NSString *)zip
{
    [self insertTempData];
    return @"";
}

+ (void) insertTempData
{
    //Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:<#(NSManagedObjectContext *)#>]
}

@end
