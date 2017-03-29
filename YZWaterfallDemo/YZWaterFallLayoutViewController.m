//
//  YZWaterFallLayoutViewController.m
//  YZWaterfallDemo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 TengNaDesign. All rights reserved.
//

#import "YZWaterFallLayoutViewController.h"
#import "YZWaterFallLayout.h"
#import "YZOneCollectionViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "YZWaterFallModel.h"


static NSString *const cellIndentifier = @"cellIndentifier";

@interface YZWaterFallLayoutViewController () <YZWaterFallLayoutDelegate,UICollectionViewDataSource,UITableViewDelegate>

/** <#注释#> **/
@property (nonatomic,strong) UICollectionView *collectionView;

/** 存放数据 **/
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YZWaterFallLayoutViewController

/** 懒加载 **/
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [self setUpLayout];
    
    [self setUpRefrsh];
    
}




- (void)setUpLayout {
    
    YZWaterFallLayout *flowLayout = [[YZWaterFallLayout alloc] init];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOneCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellIndentifier];

}

- (void)setUpRefrsh
{
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.collectionView.footer.hidden = YES;
}

- (void)loadNewData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *array = [YZWaterFallModel objectArrayWithFilename:@"WaterFall.plist"];
        [self.dataArr removeAllObjects];
        
        [self.dataArr addObjectsFromArray:array];
        
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
    
    NSLog(@"---%@--",self.dataArr);
}

- (void)loadMoreData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *array = [YZWaterFallModel objectArrayWithFilename:@"WaterFall.plist"];
        [self.dataArr addObjectsFromArray:array];
        
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    self.collectionView.footer.hidden = self.dataArr.count == 0;
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YZOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    cell.waterFallModel = self.dataArr[indexPath.item];
    return cell;
}


#pragma -- YZWaterFallLayoutDelegate
- (CGFloat)waterFallLayout:(YZWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    
    YZWaterFallModel *model = self.dataArr[index];
    
    return itemWidth * model.height / model.width;
}


//- (CGFloat)columnCountInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout {
//    
//    return 4;
//
//
//- (CGFloat)columnMarginInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout {
//    
//    return 30;
//}
//
//
//- (CGFloat)rowMarginInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout {
//    return 5;
//}
//
//- (UIEdgeInsets)edgeInsetsInWaterFallLayout:(YZWaterFallLayout *)waterFallLayout {
//    
//    return UIEdgeInsetsMake(2,2,2,50);
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
