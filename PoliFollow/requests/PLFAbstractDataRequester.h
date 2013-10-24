//
//  PLFAbstractDataRequester.h
//  PoliFollow
//
//  Created by David Segal on 10/23/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PLFAbstractDataRequester : NSObject

+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context;
+ (void)getDataByLocation:(CLLocationCoordinate2D)location withContext:(NSManagedObjectContext *)context;
+ (void)deleteRepresentativeData:(NSManagedObjectContext *)context;


@end
