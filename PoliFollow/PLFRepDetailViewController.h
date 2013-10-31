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
@property (strong, nonatomic) IBOutlet UILabel *repNameField;
@property (strong, nonatomic) IBOutlet UILabel *chamberField;
@property (strong, nonatomic) IBOutlet UILabel *stateField;
@property (strong, nonatomic) IBOutlet UILabel *districtField;
@property (strong, nonatomic) IBOutlet UILabel *partyField;
@property (strong, nonatomic) IBOutlet UILabel *twitterIdField;
@property (strong, nonatomic) IBOutlet UILabel *facebookIdField;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Representative *representative;
@property (strong, nonatomic) IBOutlet UIImageView *repImageView;

@end
