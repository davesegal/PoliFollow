//
//  PLFFindRepController.m
//  PoliFollow
//
//  Created by David Segal on 10/15/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFFindRepController.h"
#import "PLFGenericDataRequester.h"
#import "PLFSunlightDataRequester.h"
#import "PLFMyRepsTableController.h"
#import "PLFDataRequestNotifications.h"

@interface PLFFindRepController ()
{
    UIActivityIndicatorView *activityView;
    CLLocationManager *locationManager;
}

@end

@implementation PLFFindRepController

@synthesize managedObjectContext, zipcodeField, zipButton, useLocationButton;

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
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    zipButton.enabled = YES;
    useLocationButton.enabled = YES;
    zipcodeField.enabled = YES;
    zipcodeField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proccessZipCode:(id)sender
{
    zipcodeField.enabled = NO;
    zipButton.enabled = NO;
    useLocationButton.enabled = NO;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(requestProcessed:) name:PLFDataRequesterDidProcessDataNotification object:nil];
    [PLFSunlightDataRequester getDataByZipCode:zipcodeField.text withContext:managedObjectContext];
    
    
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
}

- (IBAction)getlocation:(id)sender {
	
    zipcodeField.enabled = NO;
    zipButton.enabled = NO;
    useLocationButton.enabled = NO;
	[locationManager startUpdatingLocation];
    
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
    UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	
    [locationManager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(requestProcessed:) name:PLFDataRequesterDidProcessDataNotification object:nil];
    
    [PLFSunlightDataRequester getDataByLocation:coordinate withContext:managedObjectContext];

	
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PLFMyRepsTableController *repsList = (PLFMyRepsTableController *)[segue destinationViewController];
    repsList.managedObjectContext = managedObjectContext;
}

- (void)requestProcessed:(NSNotification *)notification
{
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:PLFDataRequesterDidProcessDataNotification object:nil];
    
    if ([notification.userInfo[PLFDataRequesterRequestSuccessKey]  isEqual: @YES] )
    {
        [self performSegueWithIdentifier:@"segueToRepTableViewController" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No info available"
                                                        message:@"Make sure you have a legitimate zip code."
                                                       delegate:self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    zipcodeField.text = @"";
    zipcodeField.enabled = YES;
    zipButton.enabled = YES;
    useLocationButton.enabled = YES;
}

@end
