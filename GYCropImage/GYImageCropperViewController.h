
#import <UIKit/UIKit.h>

@interface GYImageCropperViewController : UIViewController

typedef void(^SendBlock)(UIImage *image);

@property (nonatomic, copy) SendBlock sendPhoto;

-(instancetype)initWithImage:(UIImage *)image;

@end
