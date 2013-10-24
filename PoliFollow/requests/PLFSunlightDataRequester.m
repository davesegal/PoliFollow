//
//  PLFSunlightDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/22/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFSunlightDataRequester.h"
#import "Representative.h"
#import "AFHTTPRequestOperationManager.h"
#import "PLFDataRequestNotifications.h"
#import "PLFAPIKeys.h"

NSString *const SUNLIGHT_API_URL = @"http://congress.api.sunlightfoundation.com/";


@implementation PLFSunlightDataRequester


+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context
{
    [self deleteRepresentativeData:context];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?zip=%@&output=json", SUNLIGHT_API_URL, zip];
    
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
                  [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
              }
              
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"YES"}];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
          }
     ];
    
}

+ (void) getDataByLocation:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    [self deleteRepresentativeData:context];
    // X-APIKEY
    // legislators/locate?latitude=42.96&longitude=-108.09
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%f%@%f", SUNLIGHT_API_URL, @"legislators/locate?apikey=", PLFAPIKeysSunlightKey, @"&longitude=", location.longitude, @"&latitude=", location.latitude];
    //NSDictionary *parameters = @{@"apikey":PLFAPIKeysSunlightKey, @"latitude": [NSNumber numberWithDouble:location.latitude] , @"longitude":[NSNumber numberWithDouble:location.longitude] };
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //[[manager requestSerializer] setValue:PLFAPIKeysSunlightKey forKey:@"X-APIKEY"];
    [manager GET:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              for (NSDictionary *item in responseObject[@"results"])
              {
                  NSLog(@"item  : %@", item);
                  Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
                  //rep1.district = item[@"district"];
                  rep1.email = @"";
                  rep1.firstName = item[@"first_name"];
                  rep1.lastName = item[@"last_name"];
                  rep1.name = [NSString stringWithFormat:@"%@ %@", rep1.firstName, rep1.lastName];
                  rep1.party = item[@"party"];
                  rep1.phone = item[@"phone"];
                  rep1.urlLink = @"";
                  rep1.chamber = item[@"chamber"];
                  rep1.website = item[@"website"];
                  rep1.address = item[@"office"];
                  rep1.state = item[@"state"];
                  
              }
              
              NSError *error;
              if (! [context save:&error])
              {
                  NSLog(@"Failed to save rep with error: %@", error.domain);
                  [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
              }
              
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"YES"}];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
          }
     ];

    
}


@end
