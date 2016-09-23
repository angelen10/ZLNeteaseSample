//
//  ZLGameTableViewController.m
//  ZLNeteaseSample
//
//  Created by angelen on 16/9/23.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLGameTableViewController.h"

static NSString *const kReuseIdentifier = @"GameTableViewCell";

@interface ZLGameTableViewController ()

@end

@implementation ZLGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ZLGameTableViewController -->viewDidLoad");
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.title, indexPath.row];
    return cell;
}

@end
