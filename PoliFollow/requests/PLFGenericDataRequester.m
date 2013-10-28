//
//  PLFDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/11/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFGenericDataRequester.h"
#import "Representative.h"
#import "AFHTTPRequestOperationManager.h"
#import "PLFDataRequestNotifications.h"


//http://whoismyrepresentative.com/getall_mems.php?zip=10009

NSString *const MICRO_DATA_URL = @"www.govtrack.us/api/v2/role";
NSString *const MACRO_DATA_URL = @"http://whoismyrepresentative.com";
NSString *const MACRO_ALL_MEMBERS = @"http://whoismyrepresentative.com/getall_mems.php";
NSString *const MACRO_REPS_BY_STATE = @"http://whoismyrepresentative.com/getall_reps_bystate.php";
NSString *const MACRO_SENS_BY_STATE = @"http://whoismyrepresentative.com/getall_sens_bystate.php";


@implementation PLFGenericDataRequester


+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context
{
    
    [self deleteRepresentativeData:context];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?zip=%@&output=json", MACRO_ALL_MEMBERS, zip];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"zip": zip, @"output":@"json"};
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
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
                  rep1.phone = item[@"phone"];
                  rep1.state = item[@"state"];

              }
              
              NSError *error;
              if (! [context save:&error])
              {
                  NSLog(@"Failed to save rep with error: %@", error.domain);
                  [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @NO}];
              }
              
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @YES}];
              
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @NO}];
    }];

}




@end
