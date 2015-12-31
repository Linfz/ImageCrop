# ImageCrop
A simple example  for cropping an image

# Usage
#### Use view controller component
```
CropImageViewController *cropViewController = [[CropImageViewController alloc] initWithImage:[UIImage imageNamed:@"Your image name"]];
[self presentViewController:cropViewController animated:YES completion:nil];
```

####Get the cropped image
```
cropViewController.sendPhoto = ^(UIImage *image){
        self.cropImageView.image = image;
};
```
####Specify crop rect by image size based
In file CropImageViewController.m
```
self.cropArea = [[CropAreaView alloc] initWithFrame:CGRectMake(0, 
                                                               0, 
                                                               CGRectGetWidth(self.view.frame), 
                                                               CGRectGetHeight(self.view.frame) - CGRectGetHeight(_toolBar.frame))];
[self.view addSubview:_cropArea];
self.cropArea.userInteractionEnabled = NO;
```

