//
//  PLFFindOnMapViewController.m
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFFindOnMapViewController.h"

@interface PLFFindOnMapViewController ()
{
    BOOL isUpdatingUserLocation;
}

@end

@implementation PLFFindOnMapViewController

@synthesize mapView;

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
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    isUpdatingUserLocation = YES;
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
    point.subtitle = @"tap here";
    
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


@end
