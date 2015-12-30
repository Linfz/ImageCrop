
#import "GYImageCropperViewController.h"
#import "CropAreaView.h"

#define k_TOOLSBAR_HEIGHT 44
#define k_NAV_HEIGHT CGRectGetMaxY(self.navigationController.navigationBar.frame)
#define TOOLBAR_COLOR [UIColor colorWithRed:0xf8/255.0f green:0xf8/255.0f blue:0xf8/255.0f alpha:1]

@interface GYImageCropperViewController ()<UIScrollViewDelegate>
{
    CGRect _imgFrame;
    UIToolbar *_toolBar;
    CGSize _cropSize;
    CGFloat _coverViewHeight;
    BOOL _disViewController;
}
@property (nonatomic, strong) CropAreaView *cropArea;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GYImageCropperViewController

-(instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _currentImage = image;
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createMyUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view bringSubviewToFront:self.cropArea];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Layout Views

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - k_NAV_HEIGHT - k_TOOLSBAR_HEIGHT);
    [self refreshScrollView];
}


- (void)refreshScrollView{
    
    CGRect frame = _scrollView.frame;
    frame.size.height = CGRectGetHeight(self.view.frame) - frame.origin.y - k_TOOLSBAR_HEIGHT;
    frame.size.width = CGRectGetWidth(self.view.frame);
    
    CGFloat minScale = 1.0f;
    _imgFrame.size = self.currentImage.size;
    self.scrollView.frame = frame;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.cropArea refreshUI:frame];
    _toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - k_TOOLSBAR_HEIGHT,CGRectGetWidth(self.view.frame), k_TOOLSBAR_HEIGHT);
    
    CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame);
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat imgSizeHeight = _imgFrame.size.height;
    CGFloat imgSizeWidth = _imgFrame.size.width;
    
    if (CGRectGetWidth(self.view.frame) > CGRectGetHeight(self.view.frame)) {
        _cropSize = CGSizeMake(scrollHeight, scrollHeight);
        _coverViewHeight = (scrollWidth - scrollHeight) / 2;
        
        if (imgSizeHeight < imgSizeWidth) {
            imgSizeHeight =  _cropSize.width;
            imgSizeWidth = self.currentImage.size.width * imgSizeHeight / self.currentImage.size.height;
            minScale = imgSizeWidth / _cropSize.width;
        }else{
            imgSizeWidth = _cropSize.width;
            imgSizeHeight = self.currentImage.size.height * imgSizeWidth / self.currentImage.size.width;
            minScale = imgSizeWidth / _cropSize.width;
        }
        
    }else{
        _cropSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
        _coverViewHeight = (CGRectGetHeight(frame) - CGRectGetWidth(frame)) / 2;
        if (imgSizeHeight >= imgSizeWidth) {
            imgSizeWidth = _cropSize.width;
            imgSizeHeight =   self.currentImage.size.height * imgSizeWidth / self.currentImage.size.width;
            minScale = imgSizeHeight / _cropSize.width;
        }else{
            imgSizeHeight = _cropSize.width;
            imgSizeWidth = _currentImage.size.width * imgSizeHeight / self.currentImage.size.height;
            minScale =_imgFrame.size.width / _cropSize.width;
        }
    }
    _imgFrame = CGRectMake(0, 0, imgSizeWidth, imgSizeHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake((imgSizeHeight - _cropSize.width) / 2,
                                                    (imgSizeWidth - _cropSize.width) / 2,
                                                    (imgSizeHeight - _cropSize.width) / 2,
                                                    (imgSizeWidth - _cropSize.width) / 2);
    self.scrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    _imgFrame.origin.x = (CGRectGetWidth(self.view.frame) - imgSizeWidth) / 2;
    _imgFrame.origin.y = (scrollHeight - imgSizeHeight) / 2;
    self.imageView.frame = _imgFrame;
    self.scrollView.maximumZoomScale = 20;
    self.scrollView.minimumZoomScale = 1 / minScale;
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    _scrollView.zoomScale = 1;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _scrollView.zoomScale = 1;
}

#pragma mark- Build Custom UI

- (void)createMyUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self buildToolBar];
    [self buildCoverViews];
    self.imageView.image = self.currentImage;
}

- (void)buildToolBar{
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - k_TOOLSBAR_HEIGHT, self.view.frame.size.width, k_TOOLSBAR_HEIGHT)];
    _toolBar.barTintColor = TOOLBAR_COLOR;
    UIBarButtonItem *toolbarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(usePhoto)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = @[space,toolbarItem];
    [_toolBar setItems:array];
    [self.view addSubview:_toolBar];
    [self.view bringSubviewToFront:_toolBar];
}

- (void)buildCoverViews{
    self.cropArea = [[CropAreaView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_toolBar.frame))];
    [self.view addSubview:_cropArea];
    self.cropArea.userInteractionEnabled = NO;
}

- (void)usePhoto{
    UIImage *image = [self cropImage];
    if (self.sendPhoto) {
        self.sendPhoto(image);
    }
    [self setNeedsStatusBarAppearanceUpdate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- crop image

- (UIImage *)cropImage{
    CGRect rect =self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (self.view.frame.size.width > self.view.frame.size.height) {
        rect = CGRectMake(_coverViewHeight, 1, _cropSize.width, _cropSize.width - 2);
    }else{
        rect = CGRectMake(1, _coverViewHeight, self.view.frame.size.width - 2, self.view.frame.size.width);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage],rect);
    
    UIImage * newImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImg;
}

#pragma mark- scrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat height = scrollView.frame.size.height;
    CGFloat width = scrollView.frame.size.width;
    if (self.view.frame.size.width > self.view.frame.size.height){
        width = scrollView.frame.size.width - _coverViewHeight * 2;
        if (width < scrollView.contentSize.width) {
            width = scrollView.contentSize.width;
        }
        if (height < scrollView.contentSize.height) {
            height = scrollView.contentSize.height;
        }
        CGRect frame = self.imageView.frame;
        frame.origin = CGPointMake((width - frame.size.width) / 2, (height - frame.size.height) / 2);
        self.imageView.frame = frame;
        scrollView.contentInset = UIEdgeInsetsMake(0, _coverViewHeight, 0, _coverViewHeight);
    }else{
        height = scrollView.frame.size.height - _coverViewHeight * 2;
        if (width < scrollView.contentSize.width) {
            width = scrollView.contentSize.width;
        }
        if (height < scrollView.contentSize.height) {
            height = scrollView.contentSize.height;
        }
        CGRect frame = self.imageView.frame;
        frame.origin = CGPointMake((width - frame.size.width) / 2, (height - frame.size.height) / 2);
        self.imageView.frame = frame;
        scrollView.contentInset = UIEdgeInsetsMake(_coverViewHeight, 0, _coverViewHeight, 0);
    }
}
@end
