//
//  TableViewController.h
//  Terminal
//
//  Created by 123 on 09/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Postcard.h"

@protocol TableViewControllerDelegate <NSObject>

-(void)didSelectCard:(Postcard *) postcard;

@end

@interface TableViewController : UITableViewController

@property (weak) id<TableViewControllerDelegate> delegate;
@end
