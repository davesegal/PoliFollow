//
//  Representative.h
//  PoliFollow
//
//  Created by David Segal on 10/23/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Representative : NSManagedObject

@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * urlLink;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;

@end
