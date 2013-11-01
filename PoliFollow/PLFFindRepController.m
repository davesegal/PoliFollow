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
#import "PLFFindOnMapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PLFFindRepController () <UIAlertViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    UIActivityIndicatorView *activityView;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) IBOutlet UITextField *zipcodeField;
@property (nonatomic, strong) IBOutlet UIButton *zipButton;
@property (nonatomic, strong) IBOutlet UIButton *useLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *useMapButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PLFFindRepController

@synthesize managedObjectContext, zipcodeField, zipButton, useLocationButton, useMapButton, scrollView;

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
    zipcodeField.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    useMapButton.enabled = YES;
    zipcodeField.enabled = YES;
    zipcodeField.text = @"";
    
    self.scrollView.contentOffset = CGPointZero;
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
    useMapButton.enabled = NO;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(requestProcessed:) name:PLFDataRequesterDidProcessDataNotification object:nil];
    [PLFSunlightDataRequester getDataByZipCode:zipcodeField.text withContext:managedObjectContext];
    
    
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [self removeTextFieldObservers];
    
}

- (IBAction)getlocation:(id)sender {
	
    zipcodeField.enabled = NO;
    zipButton.enabled = NO;
    useLocationButton.enabled = NO;
    useMapButton.enabled = NO;
	[locationManager startUpdatingLocation];
    
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
}

- (IBAction)goToMapView:(id)sender
{
    //segueToMapViewController
    [self performSegueWithIdentifier:@"segueToMapViewController" sender:self];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    if ([segue.identifier isEqualToString:@"segueToRepTableViewController"])
    {
        PLFMyRepsTableController *repsList = (PLFMyRepsTableController *)[segue destinationViewController];
        repsList.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"segueToMapViewController"])
    {
        PLFFindOnMapViewController *mapVC = (PLFFindOnMapViewController *)[segue destinationViewController];
        mapVC.managedObjectContext = managedObjectContext;
    }
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
    useMapButton.enabled = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [scrollView setContentOffset:CGPointMake(0.0, keyboardSize.height) animated:YES];
    useMapButton.enabled = NO;
    useLocationButton.enabled = NO;
}


- (void)keyboardWillHide:(NSNotification *)notification
{

    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self removeTextFieldObservers];

}

- (void)removeTextFieldObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}



@end
