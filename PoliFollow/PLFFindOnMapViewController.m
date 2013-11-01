//
//  PLFFindOnMapViewController.m
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFFindOnMapViewController.h"
#import "PLFSunlightDataRequester.h"
#import "PLFDataRequestNotifications.h"
#import "PLFMyRepsTableController.h"
#import <MapKit/MapKit.h>

@interface PLFFindOnMapViewController ()<MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView *activityView;
    BOOL isUpdatingUserLocation;
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *useMapLocationButton;

@end

@implementation PLFFindOnMapViewController

@synthesize mapView, useMapLocationButton, managedObjectContext;

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
    mapView.delegate = self;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:lpgr];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    self.useMapLocationButton.enabled = YES;
    isUpdatingUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (isUpdatingUserLocation)
    {
        [self moveToLocation:userLocation withAnimation:NO];
        isUpdatingUserLocation = NO;
        self.mapView.showsUserLocation = NO;
    }
    
}

- (void)moveToLocation:(MKUserLocation *)location withAnimation:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:animated];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = @"Find the Reps";
    
    [self.mapView addAnnotation:point];
}


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKUserLocation *userLoc = [[MKUserLocation alloc] init];
    userLoc.coordinate = touchMapCoordinate;
    
    [self moveToLocation:userLoc withAnimation:YES];
}

- (IBAction)useMapLocation:(id)sender
{
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    self.useMapLocationButton.enabled = NO;
    MKPointAnnotation *point = [self.mapView  annotations][0];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(requestProcessed:) name:PLFDataRequesterDidProcessDataNotification object:nil];
    
    [PLFSunlightDataRequester getDataByLocation:point.coordinate withContext:managedObjectContext];
    
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
                                                        message:@"There are no representatives there"
                                                       delegate:self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
        self.useMapLocationButton.enabled = YES;
    }

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToRepTableViewController"])
    {
        PLFMyRepsTableController *repsList = (PLFMyRepsTableController *)[segue destinationViewController];
        repsList.managedObjectContext = managedObjectContext;
    }
}

@end
