//
//  PLFFindRepController.m
//  PoliFollow
//
//  Created by David Segal on 10/15/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFFindRepController.h"
#import "PLFDataRequester.h"
#import "PLFMyRepsTableController.h"

@interface PLFFindRepController ()

@end

@implementation PLFFindRepController

@synthesize managedObjectContext, zipcodeField;

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

- (IBAction)proccessZipCode:(id)sender
{
    NSLog(@"process zip");
    [PLFDataRequester getDataByZipCode:zipcodeField.text withContext:managedObjectContext];
    [self performSegueWithIdentifier:@"segueToMainNavController" sender:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
    PLFMyRepsTableController *repsList = (PLFMyRepsTableController *)[[navController viewControllers] lastObject];
    repsList.managedObjectContext = managedObjectContext;
}


@end
