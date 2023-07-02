//
//  ZFXGestureUnLockView.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "ZFXGestureUnLockView.h"

#define HM_NUMBER 3 // 每行显示数据
#define HM_COUNT 9 // 总数据

#define HM_BUTTONTAG 10000

@interface ZFXGestureUnLockView ()

/// select btns
@property (strong, nonatomic, nullable) NSMutableArray *selectBtns;

/// current touch point
@property (assign, nonatomic) CGPoint currentPoint;

@end

@implementation ZFXGestureUnLockView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    for (NSInteger i = 0; i < HM_COUNT; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        btn.tag = HM_BUTTONTAG + i;
        
        [self addSubview:btn];
    }
    
    // 添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.lineColor = [UIColor whiteColor];
    self.lineWidth = 3;
}

/**
 * 更新界面子控件frame 布局。 因为一旦该方法执行 那么父控件frame已确定
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 74;
    CGFloat h = 74;

    // 间距
    CGFloat width = self.frame.size.width;
    CGFloat margin = (width - w * HM_NUMBER) / (HM_NUMBER + 1);
    
    // 行号和列号
    CGFloat col = 0;
    CGFloat row = 0;
    
    NSInteger count = self.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        
        col = i % HM_NUMBER;
        row = i / HM_NUMBER;
        x = margin + (w + margin) * col;
        y = margin + (h + margin) * row;
        
        UIButton *btn = (UIButton *)self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    self.currentPoint = [pan locationInView:self];
    
    // 选中按钮
    NSInteger count = self.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)self.subviews[i];
        
        if (CGRectContainsPoint(btn.frame, self.currentPoint) && btn.selected == NO) {
            btn.selected = YES;
            [self.selectBtns addObject:btn];
        }
    }
    
    // 重绘视图
    [self setNeedsDisplay];
    
    // 拖动结束，还原界面
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 保存选中的视图
        NSMutableString *pwd = [NSMutableString string];
        // 取消所有选中
        NSInteger btnCount = self.selectBtns.count;
        for (NSInteger i = 0; i < btnCount; i++) {
            UIButton *btn = self.selectBtns[i];
            btn.selected = NO;
            
            NSInteger tag = btn.tag - HM_BUTTONTAG;
            [pwd appendFormat:@"%@", [NSString stringWithFormat:@"%zd",tag]];
        }
        
        // 回调选中的密码数据 0-8随机组合
        if (self.callback) {
            self.callback(pwd);
        }
        
        if ([self.delegate respondsToSelector:@selector(gestureUnLockView:password:)]) {
            [self.delegate gestureUnLockView:self password:pwd];
        }
        
        [self.selectBtns removeAllObjects];
        self.currentPoint = CGPointZero;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSInteger count = self.selectBtns.count;
    if (count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.selectBtns[i];
        if (i == 0) {
            // 设置起点
            [path moveToPoint:btn.center];
        }
        else {
            // 添加路径
            [path addLineToPoint:btn.center];
        }
    }
    
    // 添加当前point的路径
    [path addLineToPoint:self.currentPoint];
    
    // 设置路径属性
    [self.lineColor set];
    path.lineWidth = self.lineWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

#pragma mark - setter && getter

- (NSMutableArray *)selectBtns {
    if (_selectBtns == nil) {
        _selectBtns = [NSMutableArray array];
    }
    
    return _selectBtns;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor == nil) return;
    
    _lineColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}


@end
