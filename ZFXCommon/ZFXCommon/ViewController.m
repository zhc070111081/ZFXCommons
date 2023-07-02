//
//  ViewController.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/5/25.
//

#import "ViewController.h"
#import "ZFXAnswerPageView.h"
#import "ZFXTempView.h"
#import "ZFXPageView.h"
#import "ZFXCommon.h"

@interface ViewController ()<UIZFXPageViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic, nullable) ZFXPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    ZFXPageView *pageView = [[ZFXPageView alloc] initWithFrame:self.contentView.bounds];
    pageView.delegate = self;
    [self.contentView addSubview:pageView];
    
    self.pageView = pageView;
}

- (NSInteger)numberOfPagesInPageView:(ZFXPageView *)pageView {
    return 10;
}

- (UIView *)pageView:(ZFXPageView *)pageView itemViewAtPage:(NSInteger)page {
    ZFXTempView *view = [[ZFXTempView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:(arc4random_uniform(256) * 1.0 / 255.0) green:(arc4random_uniform(256) * 1.0 / 255.0) blue:(arc4random_uniform(256) * 1.0 / 255.0) alpha:(arc4random_uniform(256) * 1.0 / 255.0)];
    return view;
}

- (IBAction)preBtnClick:(id)sender {
    [self.pageView switchToPrePageAnimated:YES];
}

- (IBAction)nextBtnClick:(id)sender {
    [self.pageView switchToNextPageAnimated:YES];
    
//    @zfx_weakify(self);
}

@end
