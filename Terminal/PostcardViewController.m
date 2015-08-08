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

CGFloat const kHeaderImageHeight = 150;

@interface PostcardViewController () <TableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *wrapper;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgressView;
@property (nonatomic) CGFloat currentTime;
@property (nonatomic) BOOL hasSeen;

@property (nonatomic) Postcard *currentPostcard;
@property (nonatomic) NSArray *postcards;
@property (nonatomic) NSInteger currentPostcardIndex;
@property (nonatomic) UIBarButtonItem *saveButton;
@property (nonatomic,getter=isShowingDescription) BOOL showingDescription; // property to hide or show

@end

@implementation PostcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wrapper.layer.cornerRadius = 10;
    self.imageView = [[UIImageView alloc] initWithFrame:self.wrapper.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.wrapper insertSubview:self.imageView belowSubview:self.timeProgressView];
    
    self.textView = [[UITextView alloc] initWithFrame:self.wrapper.bounds];
    self.textView.editable = NO;
    self.textView.selectable = NO;
   // self.textView.textAlignment = NSTextAlignmentJustified;
    [self.wrapper insertSubview:self.textView belowSubview:self.timeProgressView];
    
    self.saveButton = [UIBarButtonItem new];
    self.saveButton.title = @"Save";
    self.saveButton.target = self;
    self.saveButton.action = @selector(saveFunction);
    self.currentPostcardIndex = 0;
    self.showingDescription = NO;
    if ([PFUser currentUser][@"nextAvailableDate"]) {
        NSDate *nextDate = [PFUser currentUser][@"nextAvailableDate"];
        if ([[NSDate date] timeIntervalSinceDate:nextDate] < 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Still time to wait" message:@"Card is coming soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
            [alertView show];
        } else {
            [self getDataFromParse];
        }
    } else {
        [self getDataFromParse];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentPostcard) {
        [self showCurrentPostcard];
    }
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:21] };
}

- (void)timeProgressFunction {
    self.currentTime ++;
    self.timeProgressView.progress = self.currentTime / 60.f;
    
    if(self.currentTime > 60){
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 0.0f;
            self.textView.alpha = 0.0f;
        }];
    }
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)imageViewTapped {
    if (self.isShowingDescription) {
        [UIView animateWithDuration:0.65f animations:^{
            self.imageView.frame = self.wrapper.bounds;
            self.textView.frame = CGRectMake(0, CGRectGetHeight(self.wrapper.frame), CGRectGetWidth(self.wrapper.frame), CGRectGetHeight(self.textView.frame));
        } completion:^(BOOL finished) {
            self.showingDescription = NO;
        }];
    } else {
        [UIView animateWithDuration:0.65f animations:^{
            self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.wrapper.frame), kHeaderImageHeight);
            self.textView.frame = CGRectMake(0, kHeaderImageHeight, CGRectGetWidth(self.wrapper.frame), CGRectGetHeight(self.textView.frame));
        } completion:^(BOOL finished) {
            self.showingDescription = YES;
        }];
    }
    
    self.navigationItem.rightBarButtonItem = self.isShowingDescription ? nil : self.saveButton;
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
            [self addTapGestureRecognizer];
            [self userInteraction];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)showCurrentPostcard {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tap the picture to read description" message:@"If you like card, press SAVE button and see near hotels, otherwise it will dissapear in 60 sec" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
    [alertView show];
    [NSTimer scheduledTimerWithTimeInterval:1.f
                                     target:self
                                   selector:@selector(timeProgressFunction)
                                   userInfo:nil
                                    repeats:YES];
    self.textView.text = self.currentPostcard.text;
    [self.textView sizeToFit];
    CGFloat fontSize = 12;
    CGFloat maxHeight = CGRectGetHeight(self.wrapper.frame) - kHeaderImageHeight-30;
    while (maxHeight > CGRectGetHeight(self.textView.frame)) {
        fontSize++;
        self.textView.font = [UIFont boldSystemFontOfSize:fontSize];
        [self.textView sizeToFit];
    }
    self.textView.frame = CGRectMake(0, CGRectGetHeight(self.wrapper.frame), CGRectGetWidth(self.wrapper.frame), CGRectGetHeight(self.textView.frame));
    self.navigationItem.rightBarButtonItem = nil;
    [self setTitle:self.currentPostcard.placename];
    [self.currentPostcard.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
        } else {
            NSLog(@"%@", error);
        }
    }];
}



-(void) saveFunction {
    PFUser *user = [PFUser currentUser];
    NSMutableArray *savedCards = user[@"savedCards"] ?: [NSMutableArray new];
    [savedCards addObject:self.currentPostcard];
    user[@"savedCards"] = savedCards;
    [user saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"openTableView" sender:self];
        } else {
            NSLog(@"%@", error);
        }
    }];
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

