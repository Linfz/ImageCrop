
#import "CropAreaView.h"

#define k_COVERVIEW_HEIGHT (frame.size.height - frame.size.width) / 2

@implementation CropAreaView
{
    UIView *_topView;
    UIView *_topLineView;
    UIView *_bottomView;
    UIView *_bottomLineView;
    UIView *_leftLineView;
    UIView *_rightLineView;
    UIView *_leftView;
    UIView *_rightView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topView = [[UIView alloc] init];
        _topView.userInteractionEnabled = NO;
        [self addSubview:_topView];
        _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_topLineView];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.userInteractionEnabled = NO;
        [self addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomLineView];
        
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:_leftView];
        
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:_rightView];
        
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_leftLineView];
        
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_rightLineView];
        
    }
    return self;
}

- (void)refreshUI:(CGRect)frame{
   
    if (frame.size.width > frame.size.height){
        _topView.frame = CGRectMake(0, 0, (frame.size.width - frame.size.height) / 2 , frame.size.height);
        _topLineView.frame = CGRectMake((frame.size.width - frame.size.height) / 2, 0, frame.size.height, 1);
        _bottomView.frame = CGRectMake(frame.size.width -  (frame.size.width - frame.size.height) / 2 ,0, (frame.size.width - frame.size.height) / 2, frame.size.height);
        _bottomLineView.frame = CGRectMake((frame.size.width - frame.size.height) / 2, frame.size.height - 1,frame.size.height, 1);
        _rightLineView.frame = CGRectMake(frame.size.width -  (frame.size.width - frame.size.height) / 2, 0, 1, frame.size.height);
        _leftLineView.frame = CGRectMake((frame.size.width - frame.size.height) / 2 - 1, 0, 1, frame.size.height);
        _leftView.hidden = YES;
        _rightView.hidden = YES;

    }else{
        _leftView.hidden = NO;
        _rightView.hidden = NO;
        
        _topView.frame = CGRectMake(0, 0, frame.size.width, k_COVERVIEW_HEIGHT + 1);
        _topLineView.frame = CGRectMake(1, k_COVERVIEW_HEIGHT, frame.size.width - 2, 1);
        _bottomView.frame = CGRectMake(0,k_COVERVIEW_HEIGHT + frame.size.width -1, frame.size.width, k_COVERVIEW_HEIGHT);
        _bottomLineView.frame = CGRectMake(1, frame.size.height - k_COVERVIEW_HEIGHT - 1,frame.size.width - 2, 1);
        _rightLineView.frame = CGRectMake(frame.size.width - 2, k_COVERVIEW_HEIGHT + 1, 1, frame.size.width - 2);
        _leftLineView.frame = CGRectMake(1, k_COVERVIEW_HEIGHT + 1, 1, frame.size.width - 2);
        
        _leftView.frame = CGRectMake(0, k_COVERVIEW_HEIGHT + 1, 2, frame.size.width - 2);
        _rightView.frame = CGRectMake(frame.size.width - 2, k_COVERVIEW_HEIGHT + 1, 2, frame.size.width - 2);
    }
}


@end
