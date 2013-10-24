//
//  PLFDataRequester.h
//  PoliFollow
//
//  Created by David Segal on 10/11/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLFAbstractDataRequester.h"

@interface PLFGenericDataRequester : PLFAbstractDataRequester


+ (void)getDataByZipCode:(NSString *)zip withContext:(NSManagedObjectContext *)context;


@end
