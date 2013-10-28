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

static NSString *const SUNLIGHT_API_URL = @"http://congress.api.sunlightfoundation.com/";
static NSString *const OPEN_STATES_API_URL = @"http://openstates.org/api/v1/";
static BOOL isStateRequestComplete;
static BOOL isFedRequestComplete;
static BOOL isDataAvailable;


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

+ (void)getDataByLocation:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    isStateRequestComplete = NO;
    isFedRequestComplete = NO;
    isDataAvailable = NO;
    [self deleteRepresentativeData:context];
    [self getFederalRepData:location withContext:context];
    [self getStateRepData:location withContext:context];
    // X-APIKEY
    // legislators/locate?latitude=42.96&longitude=-108.09
   
    
}

+ (void)getStateRepData:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    ///legislators/geo/?lat=40.7222639071203&long=-73.98425035185551&apikey=";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%f%@%f%@%@", OPEN_STATES_API_URL, @"legislators/geo?lat=", location.latitude,  @"&long=", location.longitude, @"&apikey=", PLFAPIKeysSunlightKey];
    
    [manager GET:urlString parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             for (NSDictionary *item in responseObject)
             {
                 NSLog(@"item  : %@", item);
                 Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
                 rep1.district = ( item[@"district"] == [NSNull null] ) ? @"" : [NSString stringWithFormat:@"%@", item[@"district"]];
                 rep1.email = @"";
                 rep1.firstName = ( item[@"first_name"] == [NSNull null] ) ? @"" : item[@"first_name"];
                 rep1.lastName = ( item[@"last_name"] == [NSNull null] ) ? @"" : item[@"last_name"];
                 rep1.name = [NSString stringWithFormat:@"%@ %@", rep1.firstName, rep1.lastName];
                 rep1.party = ( item[@"party"] == [NSNull null] ) ? @"" : item[@"party"];
                 rep1.phone = ( item[@"phone"] == [NSNull null] ) ? @"" : item[@"phone"];
                 rep1.urlLink = @"";
                 rep1.chamber = ( item[@"chamber"] == [NSNull null] ) ? @"" : item[@"chamber"];
                 rep1.website = ( item[@"website"] == [NSNull null] ) ? @"" : item[@"website"];
                 rep1.address = ( item[@"office"] == [NSNull null] ) ? @"" : item[@"office"];
                 rep1.state = ( item[@"state"] == [NSNull null] ) ? @"" : item[@"state"];
                 rep1.facebookId = ( item[@"facebook_id"] == [NSNull null] ) ? @"" : item[@"facebook_id"];
                 rep1.twitterId = ( item[@"twitter_id"] == [NSNull null] ) ? @"" : item[@"twitter_id"];
             }
             
             NSError *error;
             if (! [context save:&error])
             {
                 NSLog(@"Failed to save rep with error: %@", error.domain);
                 isStateRequestComplete = YES;
                 [self dataRequestComplete:NO];
                 //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
             }
             else
             {
                 
                 isStateRequestComplete = YES;
                 [self dataRequestComplete:YES];
             }
             //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"YES"}];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             isStateRequestComplete = YES;
             [self dataRequestComplete:NO];
             //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
         }
     ];

}

+ (void)getFederalRepData:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%f%@%f", SUNLIGHT_API_URL, @"legislators/locate?apikey=", PLFAPIKeysSunlightKey, @"&longitude=", location.longitude, @"&latitude=", location.latitude];
    //NSDictionary *parameters = @{@"apikey":PLFAPIKeysSunlightKey, @"latitude": [NSNumber numberWithDouble:location.latitude] , @"longitude":[NSNumber numberWithDouble:location.longitude] };
    //NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //[[manager requestSerializer] setValue:PLFAPIKeysSunlightKey forKey:@"X-APIKEY"];
    [manager GET:urlString parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             for (NSDictionary *item in responseObject[@"results"])
             {
                 NSLog(@"item  : %@", item);
                 Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
                 rep1.district = ( item[@"district"] == [NSNull null] ) ? @"" : [NSString stringWithFormat:@"%@", item[@"district"]];
                 rep1.email = @"";
                 rep1.firstName = ( item[@"first_name"] == [NSNull null] ) ? @"" : item[@"first_name"];
                 rep1.lastName = ( item[@"last_name"] == [NSNull null] ) ? @"" : item[@"last_name"];
                 rep1.name = [NSString stringWithFormat:@"%@ %@", rep1.firstName, rep1.lastName];
                 rep1.party = ( item[@"party"] == [NSNull null] ) ? @"" : item[@"party"];
                 rep1.phone = ( item[@"phone"] == [NSNull null] ) ? @"" : item[@"phone"];
                 rep1.urlLink = @"";
                 rep1.chamber = ( item[@"chamber"] == [NSNull null] ) ? @"" : item[@"chamber"];
                 rep1.website = ( item[@"website"] == [NSNull null] ) ? @"" : item[@"website"];
                 rep1.address = ( item[@"office"] == [NSNull null] ) ? @"" : item[@"office"];
                 rep1.state = ( item[@"state"] == [NSNull null] ) ? @"" : item[@"state"];
                 rep1.facebookId = ( item[@"facebook_id"] == [NSNull null] ) ? @"" : item[@"facebook_id"];
                 rep1.twitterId = ( item[@"twitter_id"] == [NSNull null] ) ? @"" : item[@"twitter_id"];
             }
             
             NSError *error;
             if (! [context save:&error])
             {
                 NSLog(@"Failed to save rep with error: %@", error.domain);
                 isFedRequestComplete = YES;
                 [self dataRequestComplete:NO];
                 //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
             }
             else
             {
             
                 isFedRequestComplete = YES;
                 [self dataRequestComplete:YES];
             }
             //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"YES"}];
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             isFedRequestComplete = YES;
             [self dataRequestComplete:NO];
             //[nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: @"NO"}];
         }
     ];
}

+ (void)dataRequestComplete:(BOOL)success
{
    if (success) isDataAvailable = YES;
    
    if (isStateRequestComplete && isFedRequestComplete)
    {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:PLFDataRequesterDidProcessDataNotification object:self userInfo:@{PLFDataRequesterRequestSuccessKey: (isDataAvailable) ? @YES : @NO}];
    }
}

@end
