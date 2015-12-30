
#import "ViewController.h"
#import "GYImageCropperViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *originImageView;
@property (strong, nonatomic) UIImageView *cropImageView;
@property (strong, nonatomic) UIButton    *cropButton;

@end

@implementation ViewController

- (UIImageView *)originImageView{
    if (_originImageView != nil) {
        return _originImageView;
    }
    _originImageView = [[UIImageView alloc]init];
    _originImageView.image = [UIImage imageNamed:@"testImage"];
    return _originImageView;
}

- (UIImageView *)cropImageView{
    if (_cropImageView != nil) {
        return _cropImageView;
    }
    _cropImageView = [[UIImageView alloc]init];
    return _cropImageView;
}

- (UIButton *)cropButton{
    if (_cropButton != nil) {
        return _cropButton;
    }
    _cropButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cropButton setTitle:@"Crop" forState:UIControlStateNormal];
    [_cropButton addTarget:self action:@selector(cropButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return _cropButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildCustomUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.originImageView.frame = CGRectMake(100, 100, 100, 100);
    self.cropImageView.frame = CGRectMake(100, 300, 100, 100);
    self.cropButton.frame = CGRectMake(CGRectGetMaxX(self.originImageView.frame) + 50, 100, 50, 30);
}

- (void)buildCustomUI{
    [self.view addSubview:self.originImageView];
    [self.view addSubview:self.cropImageView];
    [self.view addSubview:self.cropButton];
}

- (void)cropButtonAction:(id)sender{
    GYImageCropperViewController *cropViewController = [[GYImageCropperViewController alloc] initWithImage:[UIImage imageNamed:@"testImage"]];
    [self presentViewController:cropViewController animated:YES completion:nil];
    
    cropViewController.sendPhoto = ^(UIImage *image){
        self.cropImageView.image = image;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
