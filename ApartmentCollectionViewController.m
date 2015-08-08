//
//  ApartmentCollectionViewController.m
//  Terminal
//
//  Created by 123 on 17/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "ApartmentCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "TableViewController.h"
#import <Parse/Parse.h>



@interface ApartmentCollectionViewController ()

@property (nonatomic) NSMutableArray *images;
@property (nonatomic) NSMutableArray *prices;
@property (nonatomic) NSMutableArray *urls;

@end

@implementation ApartmentCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = [NSMutableArray new];
    self.prices = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Apartment"];
    [query whereKey:@"postcard" equalTo:self.postcard];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *apartments, NSError *error) {
        if (!error) {
            for (PFObject *apartment in apartments) {
                [self.images addObject:apartment[@"image"]];
                [self.prices addObject:apartment[@"price"]];
                [self.urls addObject:apartment[@"url"]];
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
 [self.navigationController setNavigationBarHidden:NO];
    
    
}

#pragma mark UICollectionView methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.images) {
        return 1 + [self.images count];
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [self.postcard.image getDataInBackgroundWithBlock:^(NSData *data, NSError * error){
            if (!error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.titleLabel.text = self.postcard.placename;
            }
        }];
    } else {
        [self.images[indexPath.row-1] getDataInBackgroundWithBlock:^(NSData *data, NSError * error){
            if (!error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.titleLabel.text = self.prices[indexPath.row-1];
            }
        }];
    }
    return cell;
}


- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlString = self.urls[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


/*- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
 }];
 
} */


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/



/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


@end
