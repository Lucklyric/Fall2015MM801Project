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
@property (weak, nonatomic) MyCollectionViewCell* lastSelected;
@end
