//
//  YZOneCollectionViewCell.m
//  YZWaterfallDemo
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 TengNaDesign. All rights reserved.
//

#import "YZOneCollectionViewCell.h"

@interface YZOneCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YZOneCollectionViewCell



- (void)setWaterFallModel:(YZWaterFallModel *)waterFallModel
{
    _waterFallModel = waterFallModel;
    _pictureImage.image = [UIImage imageNamed:waterFallModel.image];
    _priceLabel.text = waterFallModel.price;
    
}




- (void)awakeFromNib {
    // Initialization code
}



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
