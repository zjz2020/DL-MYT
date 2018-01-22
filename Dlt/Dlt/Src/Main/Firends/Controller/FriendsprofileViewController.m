//
//  FriendsprofileViewController.m
//  Dlt
//
//  Created by USER on 2017/6/2.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "FriendsprofileViewController.h"
#import "UINavigationBar+Status.h"
#import "XFSegementView.h"
#import "SelectorphoteCell.h"
#import "ClassinfomationCell.h"
#import "JoingroupCell.h"
#import "JoingroupsCell.h"
#import "XTPopView.h"
#import "DLTAddPhotoTableViewCell.h"
#define SelectorphoteCellIdentifier @"SelectorphoteCellIdentifier"
#define AddPhotosCellIdentifier @"AddPhotosCellIdentifier"
#define ClassinfomationCellIdentifier @"ClassinfomationCellIdentifier"
#define JoingroupCellIdentifier @"JoingroupCellIdentifier"
#define JoingroupsCellIdentifier @"JoingroupsCellIdentifier"


@interface FriendsprofileViewController ()<UITableViewDelegate,UITableViewDataSource,TouchLabelDelegate,selectIndexPathDelegate>
{
    UILabel * bottomLine;
    XTPopView *PopView;
    UIButton * edidBtn;

}
@property(nonatomic,strong)XFSegementView * segeview;
@property(nonatomic,strong)UITableView * profileView;
@property(nonatomic,strong)UITableView * dynamicView;

@end

@implementation FriendsprofileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self addleftitem];
    // Do any additional setup after loading the view.
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(void)setup
{
    
    UIView * imageview = [[UIView alloc]init];
    imageview.frame = RectMake_LFL(0, 0, 0, 281+64);
    imageview.width_sd = WIDTH;
    imageview.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *  contentViewImageView = [[UIView alloc] init];
    [contentViewImageView addSubview:imageview];
    contentViewImageView.frame = RectMake_LFL(0, 0, 0, 212+125);
    contentViewImageView.width_sd = WIDTH;
    contentViewImageView.backgroundColor = [UIColor colorWithHexString:@"393939"];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, self.profileView.frame.size.width, 155)];
    
    backImage.backgroundColor = [UIColor yellowColor];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * singTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singTap)];
    [backImage addGestureRecognizer:singTap];
    [imageview addSubview:backImage];
    
    UIImageView  * iconimage = [[UIImageView alloc]initWithFrame:RectMake_LFL(270/2, 105, 100, 100)];
    iconimage.userInteractionEnabled = YES;
    iconimage.layer.cornerRadius = iconimage.width_sd/2;
    iconimage.layer.masksToBounds = YES;
    iconimage.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer * iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icontap)];
    [backImage addGestureRecognizer:iconTap];
    [imageview addSubview:iconimage];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:RectMake_LFL(270/2, 0, 17*6, 17)];
    nameLabel.top_sd = iconimage.bottom_sd + 10;
    nameLabel.font = AdaptedFontSize(17);
    //    nameLabel.textAlignment = NSTextAlignmentCenter;
    [imageview addSubview:nameLabel];

    edidBtn = [[UIButton alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    edidBtn.left_sd = WIDTH - 30;
    edidBtn.top_sd = backImage.bottom_sd + 15;
    [edidBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [edidBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:edidBtn];
    
    UILabel * signature = [[UILabel alloc]initWithFrame:RectMake_LFL(158/2, 0, 200, 17)];
    signature.top_sd = nameLabel.bottom_sd + 10;
    signature.font = AdaptedFontSize(14);
    signature.textColor = [UIColor colorWithHexString:@"a0a0a0"];
//    signature.text = @"什么都没说，懒懒懒懒懒懒";
    [imageview addSubview:signature];
    
    
    bottomLine = [[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 0, 10)];
    bottomLine.top_sd = signature.bottom_sd + 15;
    bottomLine.width_sd = WIDTH;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [imageview addSubview:bottomLine];
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 0, 54)];
    bottomView.top_sd = HEIGHT-54;
    bottomView.width_sd = WIDTH;
    bottomView.backgroundColor = [UIColor colorWithHexString:@"2c2c2c"];
    [self.view addSubview:bottomView];
    
    
    
    
    
    
    [imageview addSubview:self.segeview];
    self.profileView.tableHeaderView = contentViewImageView;
    
    [self.view addSubview:self.profileView];
    
    
    
}
#pragma clang diagnostic pop
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar nav_setBackgroundColor:[UIColor clearColor]];
    self.profileView.delegate = self;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    self.navigationController.navigationBar.alpha = 0;
    
    UIColor * color = [UIColor whiteColor];
    
    CGFloat offSetY = scrollView.contentOffset.y;
    //    self.isHideNav = NO;
    
    if (offSetY > 70)
    {
        CGFloat alpha = 1 - (100 - offSetY) / 70;
        //        self.backGorundView.backgroundColor = [color colorWithAlphaComponent:alpha];
        
        [self.navigationController.navigationBar nav_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
    }
    else
    {
        //        self.backGorundView.backgroundColor = [color colorWithAlphaComponent:0];
        [self.navigationController.navigationBar nav_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar nav_clear];
    self.profileView.delegate = nil;
}

-(UITableView *)profileView
{
    if (_profileView == nil) {
        _profileView = [[UITableView alloc]initWithFrame:RectMake_LFL(0, 0, WIDTH, HEIGHT)];
        _profileView.width_sd = WIDTH;
        _profileView.height_sd = HEIGHT-54;
        //        _goodsdetailsView.backgroundColor  = [UIColor redColor];
        _profileView.delegate = self;
        _profileView.dataSource = self;
        _profileView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_profileView registerClass:[SelectorphoteCell class] forCellReuseIdentifier:SelectorphoteCellIdentifier];
        [_profileView registerClass:[ClassinfomationCell class] forCellReuseIdentifier:ClassinfomationCellIdentifier];
    }
    return _profileView;
}
-(XFSegementView *)segeview
{
    if (_segeview == nil) {
        _segeview = [[XFSegementView alloc]initWithFrame:RectMake_LFL(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _segeview.top_sd = bottomLine.bottom_sd;
        _segeview.touchDelegate = self;
        _segeview.width_sd = WIDTH;
        _segeview.titleArray = @[@"资料",@"动态"];
        _segeview.titleSelectedColor = [UIColor colorWithHexString:@"0074F4"];
        _segeview.scrollLineColor = [UIColor colorWithHexString:@"0074F4"];
        _segeview.backgroundColor = [UIColor whiteColor];
        _segeview.titleFont = 17;
    }
    
    
    return _segeview;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_profileView) {
        return 3;

    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_profileView) {
        if (section==0) {
            return 2;
        }else if (section==1)
        {
            return 1;
        }else if (section==2)
        {
            return 2;
        }

    }
       return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (tableView == _profileView) {
        if (section==0) {
            if (row==0) {
                return 40;
            }else if (row==1)
            {
                return 145;
            }
        }
        if (section==1) {
            return 160;
        }
        if (section==2) {
            if (row==0) {
                return 40;
            }else
            {
                return 70;
            }
            
        }

    }
       return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (tableView== _profileView) {
        if (section==0) {
            if (row==0) {
                SelectorphoteCell * cell = [tableView dequeueReusableCellWithIdentifier:SelectorphoteCellIdentifier];
                if (cell == nil) {
                    cell = [[SelectorphoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectorphoteCellIdentifier];
                }
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else if (row==1)
            {
                DLTAddPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AddPhotosCellIdentifier];
                if (cell == nil) {
                    cell = [[DLTAddPhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddPhotosCellIdentifier];
                }
                
                return cell;
                
            }
            
        }
        if (section==1) {
            if (row==0) {
                ClassinfomationCell * cell = [tableView dequeueReusableCellWithIdentifier:ClassinfomationCellIdentifier];
                if (cell == nil) {
                    cell = [[ClassinfomationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClassinfomationCellIdentifier];
                }
                
                return cell;
            }
        }
        if (section==2) {
            if (row==0) {
                JoingroupCell * cell = [tableView dequeueReusableCellWithIdentifier:JoingroupCellIdentifier];
                if (cell==nil) {
                    cell = [[JoingroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JoingroupCellIdentifier];
                }
                return cell;
            }else if (row==1)
            {
                JoingroupsCell * cell = [tableView dequeueReusableCellWithIdentifier:JoingroupsCellIdentifier];
                if (cell==nil) {
                    cell = [[JoingroupsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JoingroupsCellIdentifier];
                }
                return cell;
                
            }
        }

    }
       return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_profileView) {
        if (section==0) {
            return 0;
        }else if (section==1)
        {
            return 10;
        }else if (section==2)
        {
            return 10;
        }

    }
        return 0;
}
- (void)touchLabelWithIndex:(NSInteger)index
{
    if (index==0) {
        NSLog(@"点击资料了");
    }else if (index==1)
    {
        NSLog(@"点击动态了");

    }
}
-(void)editClick
{
    CGPoint point = CGPointMake(edidBtn.center.x,edidBtn.frame.origin.y + 64);
    PopView = [[XTPopView alloc] initWithOrigin:point Width:130 Height:120 Type:XTTypeOfRightUp Color:[UIColor colorWithHexString:@"7f7f7f"]];
    PopView.dataArray = @[@"发送朋友",@"收藏"];
    //    view1.images = @[@"发起群聊",@"添加朋友", @"扫一扫", @"付款"];
    PopView.fontSize = 13;
    PopView.row_height = 40;
    PopView.titleTextColor = [UIColor whiteColor];
    PopView.delegate = self;
    [PopView popView];
}
- (void)selectIndexPathRow:(NSInteger )index
{
    switch (index) {
        case 0:
        {
            NSLog(@"1");
            
            break;
        }
        case 1:
        {
            NSLog(@"2");
            
            break;
        }
        case 2:
        {
            NSLog(@"3");
           
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
