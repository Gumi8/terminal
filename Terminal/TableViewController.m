//
//  TableViewController.m
//  Terminal
//
//  Created by 123 on 09/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "TableViewController.h"
#import <Parse/Parse.h>
#import "Postcard.h"
#import "PostcardViewController.h"
#import "ApartmentCollectionViewController.h"

@interface TableViewController ()

@property (nonatomic) NSMutableArray *savedCards;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.savedCards = [PFUser currentUser][@"savedCards"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:17] };
}


-(NSInteger) numberOfSectionsInTabxxleView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.imageView.image = [self imageScaledToSize:[UIImage imageNamed:@"The-Earth_1920x1080.jpg"] size:CGSizeMake(95, 75)];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Postcard *postcard = self.savedCards[indexPath.row];
    [postcard fetchIfNeededInBackgroundWithBlock:^(PFObject *postcardObject, NSError *error) {
        if (!error) {
            Postcard *fetchedPostcard = (Postcard *)postcardObject;
            NSLog(@"%@", fetchedPostcard);
            cell.textLabel.text = fetchedPostcard.placename;
            [fetchedPostcard.image getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
                cell.imageView.image = [self imageScaledToSize:[UIImage imageWithData:data] size:CGSizeMake(95, 75)];
            }];
        }
    }];
    return cell;
}

- (UIImage *)imageScaledToSize:(UIImage *)image size:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.savedCards count];
}

-( void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSString *cellText = cell.textLabel.text;
    Postcard *card = self.savedCards[indexPath.row];
    [self.delegate didSelectCard:card];
    [self performSegueWithIdentifier:@"gotoApartment" sender:nil];
   // [self.navigationController popViewControllerAnimated:YES];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoApartment"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ApartmentCollectionViewController *vc = [segue destinationViewController];
        vc.postcard = self.savedCards[indexPath.row];
    }
}



@end
