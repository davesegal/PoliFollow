//
//  PLFRepDetailViewController.m
//  PoliFollow
//
//  Created by David Segal on 10/25/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFRepDetailViewController.h"
#import "Representative+PLFDataHelper.h"
#import "UIImageView+AFNetworking.h"

@interface PLFRepDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *repNameField;
@property (strong, nonatomic) IBOutlet UILabel *chamberField;
@property (strong, nonatomic) IBOutlet UILabel *stateField;
@property (strong, nonatomic) IBOutlet UILabel *districtField;
@property (strong, nonatomic) IBOutlet UILabel *partyField;
@property (strong, nonatomic) IBOutlet UILabel *twitterIdField;
@property (strong, nonatomic) IBOutlet UILabel *facebookIdField;
@property (strong, nonatomic) IBOutlet UIImageView *repImageView;

@end

@implementation PLFRepDetailViewController

@synthesize repNameField, chamberField, stateField, districtField, partyField, twitterIdField, facebookIdField, representative, repImageView;

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
    
    NSString *imageUrl = [representative getPhotoUrl:PLFRepresentativePhotoSizeLarge];
    
    UIImage *placeHolderImage = [UIImage imageNamed:[NSString stringWithFormat:@"repImageDefault%d", PLFRepresentativePhotoSizeLarge]];

    
    if (imageUrl != nil)
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
        
        __weak UIImageView *weakImageView = repImageView;
        
        [repImageView setImageWithURLRequest:request placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakImageView.image = image;
            NSLog(@"Image success");
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Representative image failure %@", error.description);
        }];
    }
    else
    {
        repImageView.image = placeHolderImage;
    }
}




@end
