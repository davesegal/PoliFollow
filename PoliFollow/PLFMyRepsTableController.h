//
//  PLFMyRepsTableController.h
//  PoliFollow
//
//  Created by David Segal on 10/17/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLFMyRepsTableController : UITableViewController

@property (nonatomic, strong) NSMutableArray *repList;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
