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
{
    UIActivityIndicatorView *activityView;
}

@end

@implementation PLFFindRepController

@synthesize managedObjectContext, zipcodeField, zipButton;

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
    zipButton.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proccessZipCode:(id)sender
{
    zipButton.enabled = NO;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(requestProcessed:) name:PLFDataRequesterDidProcessDataNotification object:nil];
    [PLFDataRequester getDataByZipCode:zipcodeField.text withContext:managedObjectContext];
    
    
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
    PLFMyRepsTableController *repsList = (PLFMyRepsTableController *)[[navController viewControllers] lastObject];
    repsList.managedObjectContext = managedObjectContext;
}

- (void)requestProcessed:(NSNotification *)notification
{
    // remove activity indicator
    //[[[self.view subviews] lastObject] removeFromSuperview];
    
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:PLFDataRequesterDidProcessDataNotification object:self];
    [self performSegueWithIdentifier:@"segueToMainNavController" sender:self];
    
    zipButton.enabled = YES;
}

@end
