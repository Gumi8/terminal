//
//  PostcardViewController.m
//  Terminal
//
//  Created by 123 on 07/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "PostcardViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Postcard.h"
#import "TableViewController.h"

@interface PostcardViewController () <TableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) BOOL hasSeen;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger secondsCount;
@property (nonatomic) Postcard *currentPostcard;
@property (nonatomic) Postcard *nextPostcard;
@property (nonatomic) NSArray *postcards;
@property (nonatomic) NSInteger currentPostcardIndex;

@end

@implementation PostcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPostcardIndex = 0;
    if ([PFUser currentUser][@"nextAvailableDate"]) {
        NSDate *nextDate = [PFUser currentUser][@"nextAvailableDate"];
        if ([[NSDate date] timeIntervalSinceDate:nextDate] < 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Still time to wait" message:@"Card is coming soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertView show];
        } else {
            [self getDataFromParse];
            [self addTapGestureRecognizer];
        }
    } else {
        [self getDataFromParse];
        [self addTapGestureRecognizer];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self.navigationController setNavigationBarHidden:NO];
    
    if (self.currentPostcard) {
        [self showCurrentPostcard];
    }
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)imageViewTapped {
    UIView *toView = self.imageView.alpha == 0 ? self.imageView : self.textView;
    UIView *fromView = self.textView.alpha == 1 ? self.textView : self.imageView;
    [UIView transitionWithView:fromView duration:0.65f
                       options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                           fromView.alpha = 0;
                       } completion:nil];
    [UIView transitionWithView:toView duration:0.65f
                       options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                           toView.alpha = 1;
                       } completion:nil];
}

- (void)userInteraction {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *hasSeen = user[@"hasSeen"] ?: [NSMutableArray new];
    [hasSeen addObject:self.currentPostcard.objectId];
    user[@"hasSeen"] = hasSeen;
    user[@"nextAvailableDate"] = [[NSDate date] dateByAddingTimeInterval:20];
    self.currentPostcardIndex++;
    [user saveEventually];
}

- (void)getDataFromParse {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Postcard"];
    if (user[@"hasSeen"]) {
        [query whereKey:@"objectId" notContainedIn:user[@"hasSeen"]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.postcards = objects;
            self.currentPostcard = self.postcards[self.currentPostcardIndex];
            [self showCurrentPostcard];
            [self userInteraction];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)showCurrentPostcard {
    self.textView.text = self.currentPostcard.text;
    self.textView.font = [UIFont fontWithName: @"Helvetica Neue" size: 20];
    self.placeTitle.text = self.currentPostcard.placename;
    [self setTitle:self.currentPostcard.placename];
    [self.currentPostcard.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
            NSMutableArray *savedCards = [PFUser currentUser][@"savedCards"];
            if ([savedCards containsObject:self.currentPostcard]) {
                self.saveButton.hidden = YES;
            } else {
                self.saveButton.hidden = NO;
                [self setTimer];
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)setTimer {
    self.secondsCount = 60;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Card is flying away" message:@"Want to save it, then pin it in 60 sec!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
    [alertView show];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown{
    self.secondsCount--;
    self.countDownLabel.text = [NSString stringWithFormat:@"%@", @(self.secondsCount)];
    if (self.secondsCount == 0) {
        [self.timer invalidate];
        self.imageView.hidden = YES;
        self.textView.hidden =YES;
        self.placeTitle.hidden =YES;
        self.countDownLabel.hidden=YES;
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSLog(@"%@", user);
    NSMutableArray *savedCards = user[@"savedCards"] ?: [NSMutableArray new];
    [savedCards addObject:self.currentPostcard];
    user[@"savedCards"] = savedCards;
    //NSLog(@"%@", savedCards);
    [user saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.saveButton.hidden = YES;
            [self performSegueWithIdentifier:@"openTableView" sender:self];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TableViewController class]]) {
        TableViewController *nextVC = segue.destinationViewController;
        nextVC.delegate = self;
    }
}

-(void)didSelectCard:(Postcard *)postcard {
    self.currentPostcard = postcard;
}

@end

