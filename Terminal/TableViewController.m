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

@interface TableViewController ()

@property (nonatomic) NSMutableArray *savedCards;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.savedCards = [PFUser currentUser][@"savedCards"];
    NSLog(@"%@", self.savedCards);
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.imageView.image = [UIImage imageNamed:@"The-Earth_1920x1080.jpg"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    CGRect imageViewFrame = cell.imageView.frame;
    imageViewFrame.size.width = CGRectGetHeight(imageViewFrame);
    cell.imageView.frame = imageViewFrame;
    Postcard *postcard = self.savedCards[indexPath.row];
    [postcard fetchIfNeededInBackgroundWithBlock:^(PFObject *postcardObject, NSError *error) {
        if (!error) {
            Postcard *fetchedPostcard = (Postcard *)postcardObject;
            cell.textLabel.text = fetchedPostcard.placename;
            [fetchedPostcard.image getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
                cell.imageView.image = [UIImage imageWithData:data];
               // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }];
        }
    }];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.savedCards count];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-( void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    Postcard *card = self.savedCards[indexPath.row];
    [self.delegate didSelectCard:card];
    [self performSegueWithIdentifier:@"gotoApartment" sender:nil];
   // [self.navigationController popViewControllerAnimated:YES];
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        [[cell imageView] setImage:anImage];
        [[cell textLabel] setText:[NSString stringWithFormat:@"%d",[indexPath row]];
         
         return cell;
         }

    
    
    NSDictionary *item = (NSDictionary *)[self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;
} */


@end
