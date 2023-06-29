//
//  ZFXTempView.m
//  AnswerDemo
//
//  Created by zhuhc on 2023/5/24.
//

#import "ZFXTempView.h"

@interface ZFXTempView ()<UITableViewDelegate, UITableViewDataSource>

/// tableView
@property (strong, nonatomic, nullable) UITableView *tableView;

@end

@implementation ZFXTempView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor orangeColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"celiudhf"];
    [self addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celiudhf"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celiudhf"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"-------jsgfh----- %lu", indexPath.row];
    return cell;
}


@end
