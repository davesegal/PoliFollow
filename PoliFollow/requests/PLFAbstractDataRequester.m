//
//  PLFAbstractDataRequester.m
//  PoliFollow
//
//  Created by David Segal on 10/23/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFAbstractDataRequester.h"
#import "Representative.h"
#import "AFHTTPRequestOperationManager.h"
#import "PLFDataRequestNotifications.h"

@implementation PLFAbstractDataRequester


+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

+ (void)getDataByLocation:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

+ (void)deleteRepresentativeData:(NSManagedObjectContext *)context
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
