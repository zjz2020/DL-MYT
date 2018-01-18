//
//  MaYiPersonalCard.m
//  Dlt
//
//  Created by 陈杭 on 2018/1/11.
//  Copyright © 2018年 mr_chen. All rights reserved.
//

#import "MaYiPersonalCardView.h"
#import "UIImageView+WebCache.h"

@interface MaYiPersonalCardView()

@property (nonatomic , strong) UIView          * backView;        //黑色半透明图
@property (nonatomic , strong) UIView          * cardView;        //卡片白底
@property (nonatomic , strong) UIButton        * closeBtn;        //关闭按钮
@property (nonatomic , strong) UIImageView     * headImageView;   //头像
@property (nonatomic , strong) UILabel         * nameLabel;       //名字
@property (nonatomic , strong) UIImageView     * sexImageView;    //性别图片
@property (nonatomic , strong) UILabel         * introduceLabel;  //说说
@property (nonatomic , strong) UIView          * lineView;        //线
@property (nonatomic , strong) UIScrollView    * imageScrollView; //图片组
@property (nonatomic , strong) UILabel         * noneLabel;       //没有图片


@end

@implementation MaYiPersonalCardView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.backView];
        [self addSubview:self.cardView];
        
        [self.cardView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(8));
            make.right.equalTo(@(-8));
            make.width.equalTo(@(25));
            make.height.equalTo(@(25));
        }];
        
        [self.cardView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(xyzH(45)));
            make.centerX.equalTo(self.cardView.mas_centerX);
            make.width.equalTo(@(xyzW(80)));
            make.height.equalTo(@(xyzW(80)));
        }];
        
        [self.cardView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
        
        [self.cardView addSubview:self.sexImageView];
        [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.left.equalTo(self.nameLabel.mas_right).offset(15);
            make.width.equalTo(@(21));
            make.height.equalTo(@(13));
        }];
        
        [self.cardView addSubview:self.introduceLabel];
        [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.width.equalTo(@(self.cardView.width));
            make.height.equalTo(@(xyzH(14)));
        }];
        
        [self.cardView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.introduceLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.width.equalTo(@(self.cardView.width - 30));
            make.height.equalTo(@(1));
        }];
        
        [self.cardView addSubview:self.imageScrollView];
        [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.width.equalTo(@(xyzW(self.cardView.width - 30)));
            make.height.equalTo(@(xyzW(105)));
        }];
        
        [self.cardView addSubview:self.noneLabel];
        [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(15);
            make.centerX.equalTo(self.headImageView.mas_centerX);
            make.width.equalTo(@(self.cardView.width - 30));
            make.bottom.equalTo(@(-10));
        }];
        
    }
    return self;
}

#pragma -mark  -------------   私有方法  ------------

-(void)closeBtnClick{
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setModel:(MaYiPersonalCardModel *)model{

    CGAffineTransform  transform = CGAffineTransformMakeScale(0.1, 0.1);
    _cardView.transform = transform;

    _model = model;
    if(_model.userHeadImage && _model.userHeadImage.length > 0){
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userHeadImage] placeholderImage:[UIImage imageNamed:@"news_26"]];
    }
    else{
        _headImageView.image = [UIImage imageNamed:@"news_26"];
    }

    _nameLabel.text = _model.userName;
    CGRect nameSize =[_model.userName boundingRectWithSize:CGSizeMake(250,30)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(nameSize.size.width));
    }];

    UIImage  * sexImage = [UIImage imageNamed:[_model.sex isEqualToString:@"1"]?@"mayi_19":@"mayi_18"];
    _sexImageView.image = sexImage;

    _introduceLabel.text = _model.note;

    [_imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if(_model.photosArr.count > 0){
        for(int i = 0 ; i < _model.photosArr.count ; i++){
            UIImageView   * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(10+105) , 0, 105, 105)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_model.photosArr[i]]];
            [_imageScrollView addSubview:imageView];
        }
        [_imageScrollView setContentSize:CGSizeMake((10+105)*_model.photosArr.count - 10, 105)];
        _imageScrollView.alpha = 1;
        _noneLabel.alpha = 0;
    }else{
        _imageScrollView.alpha = 0;
        _noneLabel.alpha = 1;
    }

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        self.alpha = 1;
        _backView.alpha = 0.5;
        CGAffineTransform  transform = CGAffineTransformMakeScale(1.0, 1.0);
        _cardView.transform = transform;
    } completion:^(BOOL finished) {

    }];
}

#pragma -mark  -------------    初始化  ------------

-(UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
    }
    return _backView;
}

-(UIView *)cardView{
    if(!_cardView){
        _cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 * kNewScreenWScale,  365* kNewScreenHScale)];
        _cardView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.layer.cornerRadius = 10.0;
    }
    return _cardView;
}

-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeBtn setImage:[UIImage imageNamed:@"mayi_17"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = xyzW(40);
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = SDColor(44, 44, 44, 1);
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

-(UIImageView *)sexImageView{
    if(!_sexImageView){
        _sexImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sexImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _sexImageView;
}

-(UILabel *)introduceLabel{
    if(!_introduceLabel){
        _introduceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introduceLabel.textColor = SDColor(153, 153, 153, 1);
        _introduceLabel.font = [UIFont systemFontOfSize:xyzH(14)];
        _introduceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _introduceLabel;
}

-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = SDColor(211, 211, 211, 1);
    }
    return _lineView;
}

-(UIScrollView *)imageScrollView{
    if(!_imageScrollView){
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _imageScrollView;
}

-(UILabel *)noneLabel{
    if(!_noneLabel){
        _noneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _noneLabel.textColor = SDColor(44, 44, 44, 1);
        _noneLabel.font = [UIFont systemFontOfSize:20];
        _noneLabel.text = @"暂无相关图片";
        _noneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noneLabel;
}


@end
