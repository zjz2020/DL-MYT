//
//  DLTCircleoffriendDetailViewController.m
//  Dlt
//
//  Created by Gavin on 17/5/25.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLTCircleoffriendDetailViewController.h"
#import "DltUICommon.h"
#import "DLTCircleoffriendDetailHeadCell.h"
#import "DLTCircleoffriendDetailCommentCell.h"
#import "DltCircleoffriendToolbar.h"
#import "DLUserInfDetailViewController.h"

#define kDLT_CircleoffriendDetailHeadCellIdenifer @"kDLT_CircleoffriendDetailHeadCell_Idenifer"
#define kDLT_CircleoffriendDetailCommentCellIdenifer @"kDLT_CircleoffriendDetailCommentCell_Idenifer"

#define  kToolbarNormal_y (kScreenHeight - 40 - 64)

@interface DLTCircleoffriendDetailViewController () <
 UITableViewDelegate,
 UITableViewDataSource,
 DltCircleoffriendToolbarDelegate,
 DLTEmotionKeyboardDelegate,
 DLTCircleoffriendDetailHeadCellDelegate,
 DLTCircleoffriendDetailCommentDelegate
>

@property (nonatomic, weak) DLTCircleofFriendDynamicModel *model;

@property (nonatomic, weak) UIView *toolbar;
@property (nonatomic,strong) UITableView *tableView;

@property (strong, nonatomic) DLTInputView *textView;
@property (strong, nonatomic) YZEmotionKeyboard *emotionKeyboard;
@property (assign, nonatomic) CGFloat bottomCons;
@property (assign, nonatomic) CGFloat bottomHCons;
@property (assign, nonatomic, getter=isCommentArticle) BOOL commentArticle; // 是否评论文章

@end

@implementation DLTCircleoffriendDetailViewController {
  DLTCircleofFriendDynamicCommentModel *_selectedCommentModel;
}

#pragma mark -

// 懒加载键盘
- (YZEmotionKeyboard *)emotionKeyboard
{
  // 创建表情键盘
  if (_emotionKeyboard == nil) {
    
    YZEmotionKeyboard *emotionKeyboard = [YZEmotionKeyboard emotionKeyboard];
     emotionKeyboard.delegate = self;
    
    _emotionKeyboard = emotionKeyboard;
  }
  return _emotionKeyboard;
}

- (instancetype)initWithCircleoffriendDetailViewController:(DLTCircleofFriendDynamicModel *)model {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.model = model;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"详情";
  [self back:@"friends_15"];
//  self.automaticallyAdjustsScrollViewInsets = NO;
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  NSLog(@"详情: %@",self.model);
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [self.tableView registerClass:[DLTCircleoffriendDetailHeadCell class] forCellReuseIdentifier:kDLT_CircleoffriendDetailHeadCellIdenifer];
  [self.tableView registerClass:[DLTCircleoffriendDetailCommentCell class] forCellReuseIdentifier:kDLT_CircleoffriendDetailCommentCellIdenifer];
  
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 40, 0));
  }];
    
  // 监听键盘弹出
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
  
  [self setupToolbar];
    if (!_isMine) {
         [self addReportBtn];
    }
   
}
//添加举报按钮
-(void)addReportBtn{
   
     UIBarButtonItem *rpeportBtn = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(upRpeportButton)];
    [rpeportBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0], NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rpeportBtn;
    
}
-(void)upRpeportButton{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认这条动态存在色情、暴力等违规的内容吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [DLAlert alertWithText:@"工作人员将核实，并进行处理"];
    }];
   
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}
//-(void)sureReportUser{
//    DLTUserProfile * user = [DLTUserCenter userCenter].curUser;
//    NSString *url = [NSString stringWithFormat:@"%@/Temp/UserReport",BASE_URL];
//    NSDictionary *params = @{
//                             @"token" : [DLTUserCenter userCenter].token,
//                             @"uid" : user.uid,
//                             @"param1":_otherUserId,
//                             @"param2":@"举报用户"
//                             };
//    [BANetManager ba_request_POSTWithUrlString:url parameters:params successBlock:^(id response) {
//        
//        [DLAlert alertWithText:@"工作人员将核实，并进行处理"];
//    } failureBlock:^(NSError *error) {
//        [DLAlert alertWithText:@"网络延迟稍后重试"];
//    } progress:nil];
//}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
  [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [IQKeyboardManager sharedManager].enable = YES;
}

- (void)setupToolbar{
  _bottomHCons = 40;
  
  UIView *toolbar = [[UIView alloc] init];
  toolbar.backgroundColor = rgb(246, 246, 246);
  [toolbar.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, .6)] CGPath]];
  
  [self.view addSubview:toolbar];
  self.toolbar = toolbar;
  
  [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left);
    make.right.equalTo(self.view.mas_right);
    make.bottom.equalTo(self.view.mas_bottom);
    make.height.mas_equalTo(_bottomHCons);
  }];
  
  // emot
  UIButton *emotionButton = [[UIButton alloc] init];
  [emotionButton addTarget:self action:@selector(openEmotion:) forControlEvents:UIControlEventTouchUpInside];
  [emotionButton setImage:[UIImage imageWithName:@"dlt_compose_emoticonbutton_background"] forState:UIControlStateNormal];
  [toolbar addSubview:emotionButton];
  
  UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [sendButton setTitle:@"发送" forState:UIControlStateNormal];
  [sendButton setTitleColor:rgb(44, 44, 44) forState:UIControlStateNormal];
  [sendButton addTarget:self action:@selector(sendMessageButton:) forControlEvents:UIControlEventTouchUpInside];
  [toolbar addSubview:sendButton];

  [emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(40);
    make.width.mas_equalTo(60);
    make.left.equalTo(toolbar);
    make.centerY.equalTo(toolbar);
  }];
  
  [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(40);
    make.width.mas_equalTo(80);
    make.right.equalTo(toolbar.mas_right);
    make.centerY.equalTo(toolbar);
  }];

  _textView = [[DLTInputView alloc]initWithFrame:CGRectZero];
  _textView.placeholder = @"评论点什么吧";
   _textView.font = [UIFont systemFontOfSize:14];
  
  // 监听文本框文字高度改变
  @weakify(self);
  _textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
    // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
    // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
    // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
    
    @strongify(self);
    CGFloat bottomHCons = textHeight + 10;
    [self updateTextViewHeightIsConstraints:bottomHCons];
  };
  
  // 设置文本框最大行数
  _textView.maxNumberOfLines = 6;
  self.emotionKeyboard.textView = _textView;
  _textView.inputView = nil; // 切换到系统键盘
  [_textView reloadInputViews];
  
  [toolbar addSubview:_textView];
  [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(toolbar).offset(5);
    make.right.equalTo(sendButton.mas_left);
    make.left.equalTo(emotionButton.mas_right);
    make.bottom.equalTo(toolbar).offset(-5);
  }];
}

#pragma makr -

-(void)backclick{
  [super backclick];
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(circleoffriendDetailDelegate:circleofFriendModel:)]) {
    [self.delegate circleoffriendDetailDelegate:self circleofFriendModel:self.model];
  }
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.model.comments.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  if (indexPath.row == 0) {
    DLTCircleoffriendDetailHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:kDLT_CircleoffriendDetailHeadCellIdenifer];    
    headCell.indexPath = indexPath;
    headCell.model = self.model;
    headCell.dltDelegate = self;
    return headCell;
  }
  else{
    DLTCircleoffriendDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kDLT_CircleoffriendDetailCommentCellIdenifer];
    commentCell.dltCommentDelegate = self;
    commentCell.indexPath = indexPath;
    DLTCircleofFriendDynamicCommentModel *model = self.model.comments[indexPath.row - 1];
    commentCell.fModel = self.model;
    commentCell.model = model;
    return commentCell;
  }

}

#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)cellContentViewWith{
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  
  // 适配ios7
  if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
    width = [UIScreen mainScreen].bounds.size.height;
  }
  return width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//  id model = self.dataArray[indexPath.row];
  if (indexPath.row == 0) {
    return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[DLTCircleoffriendDetailHeadCell class] contentViewWidth:[self cellContentViewWith]];
  }else{
      DLTCircleofFriendDynamicCommentModel *model = self.model.comments[indexPath.row -1];
    return [DLTCircleoffriendDetailCommentCell CalculateCellHeight:model];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UIScrollView

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   [self.view endEditing:YES];
}


// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note{
  // 获取键盘frame
  CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  // 获取键盘弹出时长
  CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
  
  // 修改底部视图距离底部的间距
  CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
  CGFloat bottomCons = endFrame.origin.y != screenH? endFrame.size.height:0;
  [self updateTextViewBottomConstraints:bottomCons];
  
  // 约束动画
  [UIView animateWithDuration:duration animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)updateTextViewBottomConstraints:(CGFloat)bottomCons{
  _bottomCons = bottomCons;
  
  [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left);
    make.right.equalTo(self.view.mas_right);
    make.bottom.equalTo(self.view).offset(-_bottomCons);
    make.height.mas_equalTo(_bottomHCons);
  }];
}

- (void)updateTextViewHeightIsConstraints:(CGFloat)bottomHCons{
  _bottomHCons = bottomHCons;
  
  [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left);
    make.right.equalTo(self.view.mas_right);
    make.bottom.equalTo(self.view).offset(-_bottomCons);
    make.height.mas_equalTo(_bottomHCons);
  }];

}

#pragma makr -
#pragma makr - DltCircleoffriendToolbarDelegate

- (void)sendMessageButton:(UIButton *)button{
    [self.emotionKeyboard requestSendMessageContent];
}

/**
 *  打开表情
 */
- (void)openEmotion:(UIButton *)button{
    if (_textView.inputView == nil) {
      _textView.yz_emotionKeyboard = self.emotionKeyboard;
      [button setImage:[UIImage imageWithName:@"dlt_compose_keyboardbutton_background"] forState:UIControlStateNormal];
      [_textView becomeFirstResponder];
    } else {
      _textView.inputView = nil;
      [_textView reloadInputViews];
      [button setImage:[UIImage imageWithName:@"dlt_compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - DLTEmotionKeyboardDelegate

- (void)emotionKeyboard:(YZEmotionKeyboard *)keyboard didClickedSendEmotionDescribeMessages:(NSString *)content{
  if (content.length == 0) {return;}
  
  [self dl_networkForAddArticleCommentText:content commentModel:_selectedCommentModel isAarticle:_commentArticle];
  [_textView resetInputView];
}
#pragma mark -
#pragma mark - DLTCircleoffriendDetailHeadCellDelegate


- (DLTCircleofFriendDynamicModel *)userRequestThumbup:(DLTCircleofFriendDynamicModel *)oldModel{
  DLTCircleofFriendDynamicModel *likeModel = [oldModel copy];
  
  if (oldModel.isLiked) { // 取消 liked
    //
    NSMutableArray *newLikes = [likeModel.likes mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", DLT_USER_CENTER.curUser.uid];
    NSArray *predicateArr = [newLikes filteredArrayUsingPredicate:predicate];
    if (predicateArr.count) {
      DLTCircleofFriendDynamicLikeModel *zan = predicateArr.firstObject;
      if ([newLikes containsObject:zan]) {
        [newLikes removeObject:zan];
      }
    }
    
    likeModel.likes = newLikes;
  }else{
    DLTCircleofFriendDynamicLikeModel *zan = [DLTCircleofFriendDynamicLikeModel new];
    zan.uid = DLT_USER_CENTER.curUser.uid;
    zan.userName = DLT_USER_CENTER.curUser.userName;
    [likeModel.likes addObject:zan];
  }
  
  
  
  likeModel.liked = !oldModel.isLiked;
  return likeModel;
}

- (void)circleoffriendDetailHeadCell:(DLTCircleoffriendDetailHeadCell *)cell didClickIndex:(CGFloat)index{
    _commentArticle = YES;
  if (index == 10087) {
    [_textView becomeFirstResponder];
  }
  
  if (index == 10086) {
    [self dl_networkForModel:self.model];
  }
}

- (void)circleoffriendDetailHeadCell:(DLTCircleoffriendDetailHeadCell *)cell didTapAvatarView:(DLTCircleofFriendDynamicModel *)model{
  [self pushUserInfDetailViewControllerForUserID:model.uid];
}

- (void)pushUserInfDetailViewControllerForUserID:(NSString *)userid{
  DLUserInfDetailViewController *userVC = [DLUserInfDetailViewController new];
  userVC.otherUserId = userid;
  [self.navigationController pushViewController:userVC animated:YES];
}

#pragma mark -
#pragma mark - DLTCircleoffriendDetailCommentDelegate


- (void)circleoffriendDetailCommentCell:(DLTCircleoffriendDetailCommentCell *)cell didClickCell:(DLTCircleofFriendDynamicCommentModel *)model{
    _commentArticle = YES;
  
    BOOL isSelf =  [DLT_USER_CENTER.curUser.uid isEqualToString:model.uid];
    if (DLT_USER_CENTER.isLogged && !isSelf && model.uid.length > 0) { // 已经登录 && 评论的不是自己 && 评论的用户 id 存在
        [_textView becomeFirstResponder];
//      NSLog(@"可以回复评论");
      _selectedCommentModel = model;
      _commentArticle = NO;
    }


}

- (void)circleoffriendDetailCommentCell:(DLTCircleoffriendDetailCommentCell *)cell didTapAvatarView:(DLTCircleofFriendDynamicCommentModel *)model{
  [self pushUserInfDetailViewControllerForUserID:model.uid];
}

#pragma mark -
#pragma mark - 网络请求
/**
 添加文章评论

 @param comment 评论的内容
 @param model   当前选择的评论模型
 @param article 是否评论文章. YES: 评论文章 NO:表示评论好友
 */
- (void)dl_networkForAddArticleCommentText:(NSString *)comment commentModel:(DLTCircleofFriendDynamicCommentModel *)model isAarticle:(BOOL)article{
  
  NSString *url = [NSString stringWithFormat:@"%@Article/addArticleComment",BASE_URL];
  NSMutableDictionary *params = @{
                                  @"token" : DLT_USER_CENTER.token,
                                  @"uid"   : DLT_USER_CENTER.curUser.uid,
                                  @"articleId": self.model.articleId,
                                  @"text"  : comment
                                  }.mutableCopy;
  if (!article && model.uid.length > 0) { // 	对方用户id，若未传，即表示直接对文章评论
    [params setObject:model.uid forKey:@"toId"];
  }
  
//  NSLog(@"*****params: %@",params);

  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         
                         if ([response[@"code"] intValue] == 1) {
                            NSLog(@"评论成功: %@",response);
                             [self commentSuccess:comment];
                         }
                         
                            NSLog(@"评论返回消息: %@",response[@"msg"]);
                         
                       
                      
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:error.localizedDescription];
                         
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
  
}

- (void)commentSuccess:(NSString *)comment {
  NSMutableArray *temp = [NSMutableArray new];
  [temp addObjectsFromArray:self.model.comments];
  
   DLTUserProfile *user = [DLTUserCenter userCenter].curUser;
  DLTCircleofFriendDynamicCommentModel *model = [DLTCircleofFriendDynamicCommentModel new];
  model.userName = user.userName;
  model.text = comment;
  model.sex = [NSString stringWithFormat:@"%d",user.sex];
  model.userImg = user.userHeadImg;
  model.createTimeStamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
  
  [temp addObject:model];
  
  self.model.comments = [temp copy];
  [self.tableView reloadData];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.tableView  scrollToBottom];
  });
}


- (void)dl_networkForModel:(DLTCircleofFriendDynamicModel *)model {
  NSString *url = [NSString stringWithFormat:@"%@Article/dianZan",BASE_URL];
  DLTUserCenter *userCenter = [DLTUserCenter userCenter];
  NSDictionary *params = @{@"token" : userCenter.token,
                           @"uid"   : userCenter.curUser.uid,
                           @"articleId" : model.articleId
                           };
  @weakify(self);
  [BANetManager  ba_requestWithType:BAHttpRequestTypePost
                          urlString:url
                         parameters:params
                       successBlock:^(id response) {
                         @strongify(self);
                         if ([response[@"code"] intValue] == 1) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                             @strongify(self);
                             DLTCircleofFriendDynamicModel *likeModel = [self userRequestThumbup:model];
                             self.model = likeModel;
                             [self.tableView reloadData];
//                             [self.dataArray replaceObjectAtIndex:indexPath.row withObject:likeModel];
//                             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             [MBProgressHUD showSuccess:@"操作成功"];
                           });
                         }
                         
                         else{ [MBProgressHUD showError:@"操作失败"];}
                         
                       } failureBlock:^(NSError *error) {
                         [MBProgressHUD showError:@"操作失败"];
                       } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                         
                       }];
  
}

@end
