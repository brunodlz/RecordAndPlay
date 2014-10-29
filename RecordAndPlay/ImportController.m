//
//  ImportController.m
//  RecordAndPlay
//
//  Created by bruno da luz on 10/28/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ImportController.h"
#import "ImportCell.h"

@interface ImportController ()
{
    NSArray *arrRecordingList;
}

@end

@implementation ImportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_uitableview setDelegate:self];
    
    [self getRecordingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getRecordingList
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    
    if (!arrRecordingList) {
        arrRecordingList = [[NSArray alloc] init];
    }
    arrRecordingList = directoryContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrRecordingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImportCell *audioCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    audioCell.outletTitle.text = [arrRecordingList objectAtIndex:indexPath.row];
    
    return audioCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row Selected = %@",[arrRecordingList objectAtIndex:indexPath.row]);
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[arrRecordingList objectAtIndex:indexPath.row] forKey:@"rec"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePlay" object:self userInfo:userInfo];
    
    [self actionBack:nil];
}

- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
