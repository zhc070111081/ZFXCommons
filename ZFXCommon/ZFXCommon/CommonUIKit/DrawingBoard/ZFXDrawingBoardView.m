//
//  ZFXDrawingBoardView.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "ZFXDrawingBoardView.h"
#import "ZFXDrawBezierPath.h"

@interface ZFXDrawingBoardView ()

@property (nullable, nonatomic, strong) ZFXDrawBezierPath *path;

@property (nullable, nonatomic, strong) NSMutableArray *paths;

@end

@implementation ZFXDrawingBoardView

#pragma mark - init method
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupConfig];
}

#pragma mark - pravite method
- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
    
    self.lineWidth = 1;
    self.pathColor = [UIColor blackColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint curP = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.path = [[ZFXDrawBezierPath alloc] init];
        self.path.pathColor = self.pathColor;
        self.path.lineWidth = self.lineWidth;
        
        // 设置起点
        [self.path moveToPoint:curP];
        
        [self.paths addObject:self.path];
    }
    
    [self.path addLineToPoint:curP];
    
    [self setNeedsDisplay];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}

#pragma mark - public method
- (void)clear
{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

- (void)revoke
{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

- (void)eraser
{
    self.pathColor = [UIColor whiteColor];
}

- (void)saveImagePhotos
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (image == nil) return;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - draw method
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSInteger count = self.paths.count;
    if (count == 0) return;
    
    for (NSInteger i = 0; i < count; i++) {
        id object = self.paths[i];
        if ([object isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)object;
            [image drawInRect:rect];
        }
        else {
            ZFXDrawBezierPath *path = (ZFXDrawBezierPath *)object;
            [path.pathColor set];
            [path stroke];
        }
    }
}

#pragma mark - setter && getter

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    
    return _paths;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

- (void)setPathColor:(UIColor *)pathColor
{
    if (pathColor == nil) return;
    
    _pathColor = pathColor;
}

- (void)setImage:(UIImage *)image
{
    if (image == nil) return;
    
    _image = image;
    
    [self.paths addObject:image];
    
    [self setNeedsDisplay];
}


@end
