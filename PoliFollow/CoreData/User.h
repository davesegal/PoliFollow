//
//  User.h
//  PoliFollow
//
//  Created by David Segal on 10/17/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * state;

@end
