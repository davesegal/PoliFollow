//
//  PLFRepDetailViewController.h
//  PoliFollow
//
//  Created by David Segal on 10/25/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Representative;

@interface PLFRepDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Representative *representative;


@end
