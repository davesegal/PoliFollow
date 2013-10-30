//
//  PLFFindOnMapViewController.h
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PLFFindOnMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *useMapLocationButton;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
