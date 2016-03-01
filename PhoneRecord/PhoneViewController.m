//
//  PhoneViewController.m
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import "PhoneViewController.h"
#import "PhoneModel.h"
#import "PhoneCell.h"
#import "PhoneRecordHelper.h"

@interface PhoneViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_constactsArr;
}

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self.tableView registerClass:[PhoneCell class] forCellReuseIdentifier:@"PhoneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneCell" bundle:nil] forCellReuseIdentifier:@"PhoneCell"];
    [self.view addSubview:self.tableView];
    
    
    PhoneRecordHelper *helper = [PhoneRecordHelper defaultPhoneRecordHelper];
    if ([helper checkAddressBookAuthorizationStatus:^(NSError *error) {
        if (!error) {
            NSArray *constacts = [helper getConstacts];
            _constactsArr = constacts;
            [self.tableView reloadData];
        } else {
            NSLog(@"error = %@",error.description);
        }
    }]) {
        NSLog(@"authorized success!");
    }
    
    helper.refreshBlock = ^(void) {
        
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _constactsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCell"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillData:_constactsArr[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
