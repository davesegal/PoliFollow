//
//  PLFDataRequester.h
//  PoliFollow
//
//  Created by David Segal on 10/11/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLFDataRequester : NSObject

+ (id) getDataByZipCode:(NSString *)zip;


@end
