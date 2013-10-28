//
//  PLFRepDetailViewController.m
//  PoliFollow
//
//  Created by David Segal on 10/25/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFRepDetailViewController.h"
#import "Representative.h"

@interface PLFRepDetailViewController ()

@end

@implementation PLFRepDetailViewController

@synthesize repNameField, chamberField, stateField, districtField, partyField, twitterIdField, facebookIdField, representative;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    repNameField.text = representative.name;
    chamberField.text = representative.chamber;
    stateField.text = representative.state;
    districtField.text = [NSString stringWithFormat:@"district: %@", representative.district];
    partyField.text = representative.party;
    twitterIdField.text = [NSString stringWithFormat:@"twitter id: @%@", representative.twitterId];
    facebookIdField.text = [NSString stringWithFormat:@"facebook id: %@",representative.facebookId];
}

@end
