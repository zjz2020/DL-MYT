//
//  MainTabbarViewController.m
//  Dlt
//
//  Created by USER on 2017/5/11.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "PersonalViewController.h"
#import "FoundViewController.h"
#import "FriendsViewController.h"
#import "GreatgodViewController.h"
#import "MessageChateViewController.h"
#import "BaseNC.h"
#import <RongIMKit/RongIMKit.h>

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
@interface MainTabbarViewController ()
@property NSUInteger previousIndex;

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupAllChildViewControllers];
    
//    UIView * backview = [[UIView alloc]initWithFrame:RectMake_LFL(0, 0, WIDTH, 49)];
//    backview.backgroundColor = [UIColor colorWithHexString:@"2c2c2c"];
//    [self.tabBar insertSubview:backview atIndex:0];
//    self.tabBar.opaque = YES;
//    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(HEIGHT - 49*2);
//        make.width.mas_equalTo(WIDTH);
//        make.height.mas_equalTo(49);
//    }];
//    self.selectedIndex  =2;
  
  
  
  UIView * backview = [[UIView alloc]initWithFrame:self.tabBar.bounds];
  backview.backgroundColor = [UIColor colorWithHexString:@"2c2c2c"];
  [self.tabBar insertSubview:backview atIndex:0];
  self.tabBar.opaque = YES;
  self.selectedIndex  =2;
    self.tabBar.tintColor = [UIColor colorWithHexString:@"54bdfe"];
//    CGSize imagesize = CGSizeMake(self.tabBar.bounds.size.width/self.tabBar.items.count, self.tabBar.bounds.size.height);
//    self.tabBar.selectionIndicatorImage = [self drawTabBaritemBackgroundWitnSize:imagesize];
  
  
//    [[UITabBar appearance] setBackgroundColor:[UIColor redColor]];
//    [UITabBar appearance].translucent = NO;
    
//    [self setControllers];
//    [self setTabBarItems];
//    self.delegate = self;
//    self.selectedIndex = 2;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(changeSelectedIndex:)
//                                                 name:@"ChangeTabBarIndex"
//                                               object:nil];

//    NSArray *childItemsArray = @[
//                                 @{kClassKey  : @"MessageChateViewController",
//                                   kTitleKey  : @"消息",
//                                   kImgKey    : @"Okami_07",
//                                   kSelImgKey : @"bottom_01b"},
//                                 
//                                 @{kClassKey  : @"FoundViewController",
//                                   kTitleKey  : @"发现",
//                                   kImgKey    : @"Okami_09",
//                                   kSelImgKey : @"bottom_02b"},
//                                 
//                                 @{kClassKey  : @"GreatgodViewController",
//                                   kTitleKey  : @"大神",
//                                   kImgKey    : @"news_19",
//                                   kSelImgKey : @"bottom_03b"},
//                                 
//                                 @{kClassKey  : @"FriendsViewController",
//                                   kTitleKey  : @"好友",
//                                   kImgKey    : @"news_21",
//                                   kSelImgKey : @"bottom_04b"},
//                                 @{kClassKey  : @"PersonalViewController",
//                                   kTitleKey  : @"个人",
//                                   kImgKey    : @"news_22",
//                                   kSelImgKey : @"bottom_04b"}];
//    
//    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
//        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
//        vc.title = dict[kTitleKey];
//        BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
//        UITabBarItem *item = nav.tabBarItem;
//        item.title = dict[kTitleKey];
//        item.image = [UIImage imageNamed:dict[kImgKey]];
//        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : Global_tintColor} forState:UIControlStateSelected];
//     
//        
//        [self addChildViewController:nav];
//    }];
//
//    self.selectedIndex  = 2;
    
}
-(void)setupAllChildViewControllers {
    MessageChateViewController * messagechate = [[MessageChateViewController alloc]init];
    [self setupChildViewController:messagechate title:@"消息" imageName:@"Okami_07" selectedImageName:@"news_16"];
    FoundViewController * found = [[FoundViewController alloc]init];
     [self setupChildViewController:found title:@"发现" imageName:@"Okami_09" selectedImageName:@"friends_10"];

            GreatgodViewController * great = [[GreatgodViewController alloc]init];
              [self setupChildViewController:great title:@"大神" imageName:@"news_19" selectedImageName:@"Okami_10"];

    FriendsViewController * friends = [[FriendsViewController alloc]init];
    
      [self setupChildViewController:friends title:@"好友" imageName:@"news_21" selectedImageName:@"friend_17"];
    PersonalViewController * personal = [[PersonalViewController alloc]init];
  [self setupChildViewController:personal title:@"我" imageName:@"news_22" selectedImageName:@"personal_15"];
    
}
//- (void)setControllers {
//    MessageChateViewController * messagechate = [[MessageChateViewController alloc]init];
//    FoundViewController * found = [[FoundViewController alloc]init];
//
//    GreatgodViewController * great = [[GreatgodViewController alloc]init];
//
//    FriendsViewController * friends = [[FriendsViewController alloc]init];
//    
//    PersonalViewController * personal = [[PersonalViewController alloc]init];
//    
//    self.viewControllers = @[messagechate,found,great,friends,personal];
//    
//}
//-(void)setTabBarItems {
//    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[MessageChateViewController class]]) {
//
//            obj.tabBarItem.title = @"消息";
//            obj.tabBarItem.image = [[UIImage imageNamed:@"Okami_07"]
//                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"Okami_07"]
//                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        } else if ([obj isKindOfClass:[FoundViewController class]]) {
//
//            obj.tabBarItem.title = @"发现";
//            obj.tabBarItem.image = [[UIImage imageNamed:@"Okami_09"]
//                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"Okami_09"]
//                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        } else if ([obj isKindOfClass:[GreatgodViewController class]]) {
//
//            obj.tabBarItem.title = @"大神";
//            obj.tabBarItem.image = [[UIImage imageNamed:@"news_19"]
//                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"news_19"]
//                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        } else if ([obj isKindOfClass:[FriendsViewController class]]){
//
//            obj.tabBarItem.title = @"好友";
//            obj.tabBarItem.image = [[UIImage imageNamed:@"news_21"]
//                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"news_21"]
//                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }else if ([obj isKindOfClass:[PersonalViewController class]])
//        {
//
//            obj.tabBarItem.title = @"个人";
//            obj.tabBarItem.image = [[UIImage imageNamed:@"news_22"]
//                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"news_22"]
//                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
//        else {
//            NSLog(@"Unknown TabBarController");
//        }
//    }];
//    
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = tabBarController.selectedIndex;
   self.selectedTabBarIndex = index;
    switch (index) {
        case 0:
        {
            if (self.previousIndex == index) {
                //判断如果有未读数存在，发出定位到未读数会话的通知
                if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoNextCoversation" object:nil];
                }
                self.previousIndex = index;
            }
            self.previousIndex = index;
        }
            break;
            
        case 1:
            self.previousIndex = index;
            break;
            
        case 2:
            self.previousIndex = index;
            break;
            
        case 3:
            self.previousIndex = index;
            break;
            
        default:
            break;
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changeSelectedIndex:(NSNotification *)notify {
    NSInteger index = [notify.object integerValue];
    self.selectedIndex = index;
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedIamge = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedIamge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    BaseNC *navVc = [[BaseNC alloc] initWithRootViewController:childVc];
    [self addChildViewController:navVc];
 
}
//-(UIImage *)drawTabBaritemBackgroundWitnSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(ctx, 124.0/255, 124.0/255, 151.0/255, 1);
//    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


@end
