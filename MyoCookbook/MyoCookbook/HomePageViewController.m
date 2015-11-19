//
//  HomePageViewController.m
//  MyoCookbook
//
//  Created by Alvin Sun on 2015-11-18.
//  Copyright © 2015 Alvin Sun. All rights reserved.
//

#import "HomePageViewController.h"
#import "MyCollectionViewCell.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.recentCollection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionView"];
    self.lastSelected = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionView" forIndexPath:indexPath];
    
    //图片名称
    NSString *imageToLoad = [NSString stringWithFormat:@"sample.png"];
    //加载图片
    cell.imageData.image = [UIImage imageNamed:imageToLoad];
    //设置label文字
    cell.labelData.text = [NSString stringWithFormat:@"Sample%ld",(long)indexPath.row];
    
    return cell;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSLog(@"Choose: %ld",indexPath.row);
    MyCollectionViewCell *cell = (MyCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIColor* preColor = cell.labelData.backgroundColor;
    cell.labelData.backgroundColor = [UIColor colorWithRed:0 green: 0 blue:0 alpha:0.4];
    
    if (self.lastSelected) {
        self.lastSelected.labelData.backgroundColor = preColor;
    }
    self.lastSelected = cell;
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
