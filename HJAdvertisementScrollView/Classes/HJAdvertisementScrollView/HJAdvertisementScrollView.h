//
// HJAdvertisementScrollView
// Version 1.0.0
// Created by Jeffery He(hejicode@gmail.com) on 15/4/30.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Copyright (c) 2015 Jeffery He(hejicode@gmail.com). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@protocol HJAdvertisementScrollViewDelegte;
@class HJAdvertisementScrollModel;

@interface HJAdvertisementScrollView : UIView

/*!
 @property
 @abstract datas
 */
@property (nonatomic, strong) NSArray *datas;

/*!
 @property
 @abstract it's or not cycle, Default NO
 */
@property (nonatomic, assign) BOOL isCycle;

/*!
 @property
 @abstract it launch timer, Default NO
 */
@property (nonatomic, assign) BOOL isLaunchTimer;

/*!
 @property
 @abstract the current tint color for UIPageControl
 */
@property (nonatomic, strong) UIColor *pageControlCurrentTintColor;

/*!
 @property
 @abstract the tint color for UIPageControl
 */
@property (nonatomic, strong) UIColor *pageControlTintColor;

/*!
 @property
 @abstract THCAdvertisementBrowserViewDelegte
 */
@property (nonatomic, weak) id<HJAdvertisementScrollViewDelegte> delegate;

/*!
 @method
 @abstract open NSTimer
 */
- (void)openTimer;

/*!
 @method
 @abstract close NSTimer
 */
- (void)closeTimer;

@end

/*!
 @protocol
 @abstract HJAdvertisementScrollViewDelegte
 */
@protocol HJAdvertisementScrollViewDelegte <NSObject>

@optional
- (void)advertisementScrollView:(HJAdvertisementScrollView *)advertisementScrollView
didClickWithAdvertisementScrollModel:(HJAdvertisementScrollModel *)advertisementScrollModel;

@end

/*!
 @class
 @abstract HJAdvertisementScrollModel, wrap imageURL and webViewURL
 */
@interface HJAdvertisementScrollModel : NSObject

/*!
 @property
 @abstract imageURL
 */
@property (nonatomic, copy) NSString *imageURLString;

/*!
 @property
 @abstract webViewURL
 */
@property (nonatomic, copy) NSString *webViewURLString;

- (instancetype)initWithImageURLString:(NSString *)imageURLString
                      webViewURLString:(NSString *)webViewString;

+ (instancetype)advertisementScrollModelWithImageURLString:(NSString *)imageURLString
                                          webViewURLString:(NSString *)webViewString;
@end

