//
//  StepsViewController.h
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-20.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCollectionViewCell;
@interface CollectionViewController :  UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myoStatusLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (assign,nonatomic) NSInteger trackingLine; //1,back,2,collection 3,startAll
@property (assign,nonatomic) NSInteger trackingStatus; //1,cursor,2,menue
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *startAllButton;
@property (strong,nonatomic) NSMutableArray* sourceArray;
@property (weak,nonatomic) MyCollectionViewCell* lastSelect;
@property (weak,nonatomic)  UIViewController *fromView;

@end
