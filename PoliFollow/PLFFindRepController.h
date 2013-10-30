//
//  PLFFindRepController.h
//  PoliFollow
//
//  Created by David Segal on 10/15/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PLFFindRepController : UIViewController <UIAlertViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UITextField *zipcodeField;
@property (nonatomic, strong) IBOutlet UIButton *zipButton;
@property (nonatomic, strong) IBOutlet UIButton *useLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *useMapButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end
