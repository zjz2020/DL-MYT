//
//  DLGroupDetailViewController.m
//  Dlt
//
//  Created by Liuquan on 17/6/3.
//  Copyright © 2017年 mr_chen. All rights reserved.
// 群详细资料

#import "DLGroupDetailViewController.h"
#import "DLGroupsModel.h"
#import "DltUICommon.h"
#import "RCHttpTools.h"
#import "DLGroupMemberModel.h"
#import "DLGroupHeadImg.h"
#import "SDCycleScrollView.h"
#import "UINavigationBar+Awesome.h"
#import "ConversationViewController.h"
#import "DLGroupSetupViewController.h"

static NSString * const kgroupDetailItemId = @"groupDetailItemId";

@interface DLGroupDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLayoutW;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyJoinBtn;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupNumber;
@property (weak, nonatomic) IBOutlet UILabel *groupCount;
@property (weak, nonatomic) IBOutlet UILabel *groupDetail;
@property (weak, nonatomic) IBOutlet UILabel *joinCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (nonatomic, strong) NSMutableArray *memberArr;
@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (nonatomic, strong) SDCycleScrollView *looperBanner;
@end

@implementation DLGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群资料";
    
    self.managerBtn.hidden = self.enterGroupBtn.hidden = !self.isJoined;
    self.applyJoinBtn.hidden = self.isJoined;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (self.groupsInfo) {
        self.groupName.text = self.groupsInfo.name;
        if (ISNULLSTR(self.groupsInfo.name)) {
            self.groupName.text = self.groupsInfo.groupName;
        }
        self.groupNumber.text = [NSString stringWithFormat:@"群号：%@",self.groupsInfo.groupId];
        if (ISNULLSTR(self.groupsInfo.note)) {
            self.groupDetail.text = @"暂无";
        } else {
            self.groupDetail.text = self.groupsInfo.note;
        }
        NSString *time = [self messageReceiveTime:self.groupsInfo.createTime];
     
        self.creatTime.text = [NSString stringWithFormat:@"创建时间：%@",time];
        if (ISNULLSTR(self.groupsInfo.createTime)) {
            self.creatTime.text = @"未知";
        }
        self.joinCount.text = [NSString stringWithFormat:@"%@/3000",self.groupsInfo.count];
    }
    
    [self.collectionView registerClass:[DLGroupImageCell class] forCellWithReuseIdentifier:kgroupDetailItemId];
    [self.memberArr removeAllObjects];
    
    [self creatHeadLooper];
    
    // 获取群成员
    @weakify(self)
    [[RCHttpTools shareInstance] getGroupMembersByGroupId:self.groupsInfo.groupId handle:^(NSArray *members) {
       @strongify(self)
       dispatch_async(dispatch_get_main_queue(), ^{
           self.joinCount.text = [NSString stringWithFormat:@"%ld/3000",(long)members.count];
       });
        [self.memberArr addObjectsFromArray:members];
        [self.collectionView reloadData];
    }];
}
- (NSString *)messageReceiveTime:(NSString *)reciveTime {
    NSTimeInterval interval    =[reciveTime doubleValue] +28800;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return [NSString stringWithFormat:@"%@",dateString];
}
- (void)creatHeadLooper {
    self.looperBanner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"default_group"]];
    self.looperBanner.backgroundColor = [UIColor whiteColor];
    self.looperBanner.autoScrollTimeInterval = 5;
    self.looperBanner.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.looperBanner.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    [self.headScrollView addSubview:self.looperBanner];
    if (!ISNULLSTR(self.groupsInfo.imgs)) {
        NSArray *arr = [self.groupsInfo.imgs componentsSeparatedByString:@";"];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *str in arr) {
            [temp addObject:[NSString stringWithFormat:@"%@%@",BASE_IMGURL,str]];
        }
        self.looperBanner.imageURLStringsGroup = temp.mutableCopy;
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.backViewLayoutH.constant = kScreenSize.height + 50;
    self.backViewLayoutW.constant = kScreenSize.width;
    if (kScreenSize.width <= 320) {
       self.backViewLayoutH.constant = kScreenSize.height + 100;
    }
}

#pragma mark - delegate
#pragma mark - collectionview / delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {return 1;}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLGroupImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kgroupDetailItemId forIndexPath:indexPath];
    DLGroupMemberInfo *info = self.memberArr[indexPath.item];
    NSString *headImg = [NSString stringWithFormat:@"%@%@",BASE_IMGURL,info.headImg];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"wallet_11"]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

/// 进入群聊
- (IBAction)enterGroupChat:(UIButton *)sender {
    ConversationViewController *conversation = [[ConversationViewController alloc] init];
    conversation.conversationType = ConversationType_GROUP;
    conversation.targetId = self.groupsInfo.groupId;
    conversation.title = self.groupsInfo.name;
    [self.navigationController pushViewController:conversation animated:YES];
}

/// 管理设置
- (IBAction)managerGroupInfo:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DLGroupSetupViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DLGroupSetupViewController"];
    vc.groupId = self.groupsInfo.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 申请加入该群
- (IBAction)applyJoinGroup:(UIButton *)sender {
    [[RCHttpTools shareInstance] applyJoinGroupByGroupId:self.groupsInfo.groupId handle:^(BOOL isSuccess) {
        if (isSuccess) {
            [DLAlert alertWithText:@"申请成功"];
        } else {
            [DLAlert alertWithText:@"申请失败"];
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)memberArr {
    if (!_memberArr) {
        _memberArr = [NSMutableArray array];
    }
    return _memberArr;
}



@end
