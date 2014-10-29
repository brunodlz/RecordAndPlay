//
//  ImportController.h
//  RecordAndPlay
//
//  Created by bruno da luz on 10/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *uitableview;
- (IBAction)actionBack:(id)sender;

@end
