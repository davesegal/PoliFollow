//
//  PLFSunlightDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/22/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFSunlightDataRequester.h"
#import "Representative.h"
#import "Representative+PLFDataHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "PLFDataRequestNotifications.h"
#import "PLFAPIKeys.h"

static NSString *const SUNLIGHT_API_URL = @"http://congress.api.sunlightfoundation.com/";
static NSString *const OPEN_STATES_API_URL = @"http://openstates.org/api/v1/";
static NSString *const VOTE_SMART_API_URL = @"";

static BOOL isStateRequestComplete;
static BOOL isFedRequestComplete;
static BOOL isDataAvailable;



@implementation PLFSunlightDataRequester


+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context
{
    [self deleteRepresentativeData:context];
    
    // Need to find api to get state rep data
    isStateRequestComplete = YES;
    isFedRequestComplete = NO;
    isDataAvailable = NO;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@", SUNLIGHT_API_URL, @"legislators/locate?apikey=", PLFAPIKeysSunlightKey, @"&zip=", zip];
    
    [self handleFederalDataRequest:urlString withContext:context];
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
                 [rep1 deserializeData:item ofRepType:PLFRepresentativeTypeStateRep ];
             }
             
             NSError *error;
             if (! [context save:&error])
             {
                 NSLog(@"Failed to save rep with error: %@", error.domain);
                 isStateRequestComplete = YES;
                 [self dataRequestComplete:NO];
             }
             else
             {
                 
                 isStateRequestComplete = YES;
                 [self dataRequestComplete:YES];
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             isStateRequestComplete = YES;
             [self dataRequestComplete:NO];
             
         }
     ];

}

+ (void)getFederalRepData:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%f%@%f", SUNLIGHT_API_URL, @"legislators/locate?apikey=", PLFAPIKeysSunlightKey, @"&longitude=", location.longitude, @"&latitude=", location.latitude];
    [self handleFederalDataRequest:urlString withContext:context];
    
}

+(void)handleFederalDataRequest:(NSString *)url withContext:(NSManagedObjectContext *)context
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if ( ![responseObject[@"count"] isEqualToNumber:@0]  )
             {
                 for (NSDictionary *item in responseObject[@"results"])
                 {
                     NSLog(@"item  : %@", item);
                     Representative *rep1 = (Representative *)[NSEntityDescription insertNewObjectForEntityForName:@"Representative" inManagedObjectContext:context];
                     [rep1 deserializeData:item ofRepType:PLFRepresentativeTypeFederalRep];
                 }
                 
                 NSError *error;
                 if (! [context save:&error])
                 {
                     NSLog(@"Failed to save rep with error: %@", error.domain);
                     isFedRequestComplete = YES;
                     [self dataRequestComplete:NO];
                 }
                 else
                 {
                     
                     isFedRequestComplete = YES;
                     [self dataRequestComplete:YES];
                 }
             }
             else
             {
                 NSLog(@"no data returned: %@", responseObject);
                 isFedRequestComplete = YES;
                 [self dataRequestComplete:NO];
                 
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             isFedRequestComplete = YES;
             [self dataRequestComplete:NO];
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
