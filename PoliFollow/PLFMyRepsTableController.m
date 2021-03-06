//
//  PLFMyRepsTableController.m
//  PoliFollow
//
//  Created by David Segal on 10/17/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "PLFMyRepsTableController.h"
#import "Representative.h"
#import "Representative+PLFDataHelper.h"
#import "CoreDataUtil.h"
#import "PLFRepDetailViewController.h"

@interface PLFMyRepsTableController ()

@property (nonatomic, strong) NSMutableArray *fedReps;
@property (nonatomic, strong) NSMutableArray *fedSens;
@property (nonatomic, strong) NSMutableArray *stateReps;

@end

@implementation PLFMyRepsTableController

@synthesize fedReps, fedSens, stateReps, managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //repList = [CoreDataUtil getObjectsForEntity:@"Representative" withSortKey:@"name" andSortAscending:YES andContext:managedObjectContext];
    
    NSPredicate *fedHousePredicate = [NSPredicate predicateWithFormat:@"category = %d", PLFRepresentativeTypeFederalHouse];
    fedReps = [CoreDataUtil searchObjectsForEntity:@"Representative" withPredicate:fedHousePredicate andSortKey:@"name" andSortAscending:YES andContext:managedObjectContext];
    
    NSPredicate *fedSenPredicate = [NSPredicate predicateWithFormat:@"category = %d", PLFRepresentativeTypeFederalSenate];
    fedSens = [CoreDataUtil searchObjectsForEntity:@"Representative" withPredicate:fedSenPredicate andSortKey:@"name" andSortAscending:YES andContext:managedObjectContext];
    
    NSPredicate *stateRepPredicate = [NSPredicate predicateWithFormat:@"category = %d", PLFRepresentativeTypeStateRep];
    stateReps = [CoreDataUtil searchObjectsForEntity:@"Representative" withPredicate:stateRepPredicate andSortKey:@"name" andSortAscending:YES andContext:managedObjectContext];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)returnToFindByLocation:(id)sender

{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSInteger count = 0;
    //if ([fedSens count] > 0) ++count;
    
    //if ([fedReps count] > 0) ++count;
    
    //if ([stateReps count] > 0) ++count;
    
    // TODO -- make error condition for count == 0
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [fedSens count];
        case 1:
            return [fedReps count];
        case 2:
            return [stateReps count];
        default:
            return 0;
    }
    
    if (section == 0) {
        return [fedSens count];
    }
    
    //return [repList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Representative *rep;
    switch (indexPath.section) {
        case 0:
            
            rep = fedSens[indexPath.row];
            cell.textLabel.text = rep.name;
            break;
            
        case 1:
            rep = fedReps[indexPath.row];
            cell.textLabel.text = rep.name;
            break;
            
        case 2:
            rep = stateReps[indexPath.row];
            cell.textLabel.text = rep.name;
            break;
            
        default:
            break;
    };

    
    
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Representative *rep;
    switch (indexPath.section) {
        case 0:
            rep = fedSens[indexPath.row];
            break;
            
        case 1:
            rep = fedReps[indexPath.row];
            break;
            
        case 2:
            rep = stateReps[indexPath.row];
            break;
            
        default:
            break;
    };

    PLFRepDetailViewController *repDetailView = [[self storyboard] instantiateViewControllerWithIdentifier:@"PLFRepDetailViewController"];
    repDetailView.representative = rep;
    [[self navigationController] pushViewController:repDetailView animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"US Senate";
            
        case 1:
            return @"US House of Reps";
        
        case 2:
            return @"State Reps";
            
            
        default:
            break;
    };
    return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //PLFRepDetailViewController *repDetail = (PLFRepDetailViewController *)segue.destinationViewController;
    //repDetail.managedObjectContext = managedObjectContext;
    
    
}


@end
