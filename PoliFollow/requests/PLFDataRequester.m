//
//  PLFDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/11/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFDataRequester.h"
#import "Representative.h"
#import "AFHTTPRequestOperationManager.h"


//http://whoismyrepresentative.com/getall_mems.php?zip=10009

NSString *const MICRO_DATA_URL = @"www.govtrack.us/api/v2/role";
NSString *const MACRO_DATA_URL = @"http://whoismyrepresentative.com";
NSString *const MACRO_ALL_MEMBERS = @"http://whoismyrepresentative.com/getall_mems.php";
NSString *const MACRO_REPS_BY_STATE = @"http://whoismyrepresentative.com/getall_reps_bystate.php";
NSString *const MACRO_SENS_BY_STATE = @"http://whoismyrepresentative.com/getall_sens_bystate.php";

NSString *const PLFDataRequesterDidProcessDataNotification = @"PLFDataRequesterDidProcessData";

@implementation PLFDataRequester


+ (id) getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context
{
    
    [self deleteTempData:context];
    
    /*
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"hasRunBefore"] != YES)
    {
        [prefs setBool:YES forKey:@"hasRunBefore"];
        [prefs synchronize];
        [self insertTempData:context];
    }
     */
    
    NSString *urlString = [NSString stringWithFormat:@"%@?zip=%@&output=json", MACRO_ALL_MEMBERS, zip];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"zip": zip, @"output":@"json"};
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"JSON: %@", responseObject);
              for (NSDictionary *item in responseObject[@"results"])
              {
                  NSLog(@"item  : %@", item);
                  Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
                  rep1.district = item[@"district"];
                  rep1.urlLink = item[@"link"];
                  rep1.name = item[@"name"];
                  rep1.address = item[@"office"];
                  rep1.party = item[@"party"];
                  rep1.phoneNumber = item[@"phone"];
                  rep1.state = item[@"state"];

              }
              NSError *error;
              if (! [context save:&error])
                  NSLog(@"Failed to save rep with error: %@", error.domain);
              
              NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{@"success": @YES}];
              
              
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    return @"";
}


+ (void) insertTempData:(NSManagedObjectContext *)context
{
    
    Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
    rep1.name = @"Doug Stover";
    rep1.email = @"doug@house.gov";
    rep1.type = @"House";
    
    
    Representative *rep2 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
    rep2.name = @"Betty Stample";
    rep2.email = @"betty@house.gov";
    rep2.type = @"House";
    
    
    Representative *rep3 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
    rep3.name = @"Dawn Teltwent";
    rep3.email = @"dawn@house.gov";
    rep3.type = @"House";
    
    NSError *error;
    if (! [context save:&error])
        NSLog(@"Failed to save rep with error: %@", error.domain);
    
}

+ (void) deleteTempData:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Representative" inManagedObjectContext:context];
    [request setEntity:entity];
    
    [request setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray *fetchRequests = [context executeFetchRequest:request error:&error];
    
    if (fetchRequests != nil)
    {
        for (NSManagedObject *managedObject in fetchRequests)
        {
            [context deleteObject:managedObject];
        }
    }
    else
    {
        NSLog(@"No objects to delete for entity");
    }
    
    if ( ![context save:&error] )
         NSLog(@"Failed to save rep with error: %@", error.domain);
}

@end
