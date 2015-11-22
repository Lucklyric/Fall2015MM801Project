//
//  HomePageViewController.h
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-18.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCollectionViewCell;
@interface HomePageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *recentCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *featureCollection;
@property (assign,nonatomic) NSInteger trackingStatus; //1-Cusor,2-Menu // 3-Collection
@property (assign,nonatomic) NSInteger cursorLine; //1-feature,2
@property (weak, nonatomic) IBOutlet UITextField *searchBarField;
@property (weak, nonatomic) MyCollectionViewCell* lastFeatureSelected;
@property (weak, nonatomic) IBOutlet UILabel *myoStatusLabel;
@property (weak, nonatomic) MyCollectionViewCell* lastRecentSelected;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancleLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveForLaterLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *menuImage;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@end
