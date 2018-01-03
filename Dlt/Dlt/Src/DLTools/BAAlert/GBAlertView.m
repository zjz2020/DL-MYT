//
//  GBAlertView.m
//  测试demo
//
//  Created by mac on 2017/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GBAlertView.h"
#import "GBAlertCell.h"
#import "GroupandStoreCell.h"

#define GBDefaultCellHeight 54
#define GBAlertCellHeight 80
@interface GBAlertView ()
@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表
@end

static NSString *const GBAlertCellID = @"GBAlertCell";
static NSString *const GroupandStoreCellID = @"GroupandStoreCell";

@implementation GBAlertView
{
    float alertHeight;//弹框整体高度，默认250
}
#pragma mark -- 创建alertView
+ (GBAlertView *)showWithtTtles:(NSArray *)titles
                   itemIndex:(itemClickAtIndex)itemIndex{
    GBAlertView *alert = [[GBAlertView alloc] initWithTitles:titles itemIndex:itemIndex];
    return alert;
}
#pragma mark -- 初始化alertView
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8;
        _alertView.layer.masksToBounds = YES;
    
    }
    return _alertView;
}
#pragma mark -- 初始化selectTableView
- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.scrollEnabled = NO;
        _selectTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_selectTableView registerClass:[GroupandStoreCell class] forCellReuseIdentifier:GroupandStoreCellID];
        
    }
    return _selectTableView;
}
- (instancetype)initWithTitles:(NSArray *)titles itemIndex:(itemClickAtIndex)itemIndex{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        alertHeight = 200;
        
        _titles = titles;
        _itemIndex = [itemIndex copy];

        [self addSubview:self.alertView];
        [self.alertView addSubview:self.selectTableView];
        [self initUI];
        
        [self show];
    }
    return self;
}
- (void)initUI {
    self.alertView.frame = CGRectMake(15, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0, 0, 219);
    self.alertView.width_sd=WIDTH-30;
    self.selectTableView.frame = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height);
 
}
#pragma mark -- 弹出视图
- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}
-(UIView *)heardview
{
    UIView * view =[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 0, 54)];
    view.width_sd = self.alertView.width_sd;
    [self addSubview:view];
    UILabel * label =[[UILabel alloc]initWithFrame:RectMake_LFL(0, 37/2, 180, 18)];
    label.left_sd = WIDTH/2-90;
    label.font = AdaptedFontSize(18);
    label.text = @"选择支付方式";
    [view addSubview:label];
    
    return view;
}
#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GBDefaultCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self heardview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
//    if (indexPath.row == 2) {
//        GBAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:GBAlertCellID];
//        cell.title.text = _titles[indexPath.row][0][@"title"];
//        cell.detail.text = _titles[indexPath.row][1][@"value"];
//        
//        return cell;
//    }else{
//    
//        static NSString *const baseCellID = @"baseCellID";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCellID];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCellID];
//        }
//        cell.textLabel.text = _titles[indexPath.row];
//        return cell;
//    }
    
    if (indexPath.row==0) {
        GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellID];
        if (cell== nil) {
            cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellID];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_08",@"title":@"支付宝"}];
        return cell;
    }else if (indexPath.row==1)
    {
        GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellID];
        if (cell== nil) {
            cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_09",@"title":@"微信"}];
        return cell;

    }else if (indexPath.row==2)
    {
        GroupandStoreCell * cell =[tableView dequeueReusableCellWithIdentifier:GroupandStoreCellID];
        if (cell== nil) {
            cell =[[GroupandStoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupandStoreCellID];
        }
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell file:@{@"icon":@"wallet_10",@"title":@"银行卡"}];
        return cell;
    }
    
    return nil;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemIndex) {
        self.itemIndex(indexPath.row);
    }
    
    [self closeAction];
}
#pragma mark -- 关闭视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt)) {
        [self closeAction];
    }
}
- (void)closeAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
