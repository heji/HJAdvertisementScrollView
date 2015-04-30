//
//  TestViewController.m
//  HJAdvertisementScrollView
//
//  Created by Jeffery He on 15/4/30.
//  Copyright (c) 2015年 Jeffery He. All rights reserved.
//

#import "TestViewController.h"
#import "HJAdvertisementScrollView.h"

@interface TestViewController () <HJAdvertisementScrollViewDelegte>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HJAdvertisementScrollModel *model1 = [HJAdvertisementScrollModel advertisementScrollModelWithImageURLString:@"http://www.damndigital.com/wp-content/uploads/2013/03/damndigital_advertising-creative_2013-03_01.jpg" webViewURLString:nil];
    HJAdvertisementScrollModel *model2 = [HJAdvertisementScrollModel advertisementScrollModelWithImageURLString:@"http://www.liangao.com/Cache/Images/Default/turn_banner_1.jpg" webViewURLString:nil];
    HJAdvertisementScrollModel *model3 = [HJAdvertisementScrollModel advertisementScrollModelWithImageURLString:@"http://www.wjvis.com/flash/9.jpg" webViewURLString:nil];
    HJAdvertisementScrollView *browserView = [[HJAdvertisementScrollView alloc] init];
    browserView.isCycle = YES;
    browserView.isLaunchTimer = YES;
    browserView.delegate = self;
    //    browserView.pageControlCurrentTintColor = [UIColor redColor];
    //    browserView.pageControlTintColor = [UIColor blackColor];
    browserView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 120.0f);
    browserView.datas = @[model1, model2, model3];
    [self.view addSubview:browserView];
    
}

- (void)advertisementScrollView:(HJAdvertisementScrollView *)advertisementScrollView didClickWithAdvertisementScrollModel:(HJAdvertisementScrollModel *)advertisementScrollModel {
    NSLog(@"advertisementScrollModel.imageURLStr = %@", advertisementScrollModel.imageURLString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
