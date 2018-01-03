//
//  DLGroudNoticeViewController.m
//  Dlt
//
//  Created by USER on 2017/9/13.
//  Copyright © 2017年 mr_chen. All rights reserved.
//

#import "DLGroudNoticeViewController.h"

@interface DLGroudNoticeViewController ()<UITextViewDelegate>
@property (nonatomic , strong)UITextView *textView;
@property (nonatomic , strong)UILabel *label;
@end

@implementation DLGroudNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"群公告";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTextView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

-(void)setUpTextView{
    _textView = [UITextView new];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.frame = CGRectMake(0, 20 + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.width*0.5);
    [self.view addSubview:_textView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(7 , 7, self.view.bounds.size.width-10, 21)];
    _label.text = @"输入内容";
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = [UIColor grayColor];
    _label.enabled = NO;//lable必须设置为不可用
    [_textView addSubview:_label];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    //添加提交按钮
    UIBarButtonItem *releaseButon=[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(preservationBtn)];
    
    
    if (textView.text.length == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        _label.text = @"输入内容";
    }else{
        _label.text = @"";
        self.navigationItem.rightBarButtonItem=releaseButon;
    }
}
//点击发布
-(void)preservationBtn{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"groudNotioce" object:_textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
