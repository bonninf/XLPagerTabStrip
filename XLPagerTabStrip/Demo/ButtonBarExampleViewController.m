//
//  ButtonContainerViewController.m
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
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

#import "TableChildExampleViewController.h"
#import "ChildExampleViewController.h"
#import "ButtonBarExampleViewController.h"

@implementation ButtonBarExampleViewController
{
    BOOL _isReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = NO;
    // Do any additional setup after loading the view.
    [self.buttonBarView.selectedBar setBackgroundColor:[UIColor orangeColor]];
    
    //fb:gh#1: register the ButtonCell.xib to illustrate the use of the image inside the bar button cell.
    [self.buttonBarView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil]  forCellWithReuseIdentifier:@"Cell"];
    
    //fb:gh#2: below 5 items then the buttons get the same width
    self.maxItemsForBarWidth = 4;
}

#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    //fb:gh#2: the method is modified to easily be able selecting the max number of child pages to build
    NSUInteger childMax = 4;

    NSArray *modelChilds = @[[[TableChildExampleViewController alloc] initWithStyle:UITableViewStylePlain], [[ChildExampleViewController alloc] init], [[TableChildExampleViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    NSUInteger modelCount = [modelChilds count];
    
    NSMutableArray *childControllers = [NSMutableArray array];
    for (int i=0; i<childMax; i++) {
        int index = i % modelCount;
        
        // create child view controllers that will be managed by XLPagerTabStripViewController
        id child = modelChilds[index];
        
        //fb:bb#1: each page is associated to an index to be able to distinguish it in the imageForPagerTabStripViewController delegate method.
        [child setChildIndex:i];
        [childControllers addObject:child];
    }
    
    NSArray *resultArray;
    if (!_isReload){
        resultArray = [NSArray arrayWithArray:childControllers];
    }
    else {
        NSUInteger nItems = 1 + (rand() % modelCount);
        
        //    NSMutableArray * childViewControllers = [NSMutableArray arrayWithObjects:child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8, nil];
        //    NSUInteger nItems = 1 + (rand() % 8);
        
        NSUInteger count = [childControllers count];
        for (NSUInteger i = 0; i < count; ++i) {
            // Select a random element between i and end of array to swap with.
            NSUInteger nElements = count - i;
            NSUInteger n = (arc4random() % nElements) + i;
            [childControllers exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        resultArray = [childControllers subarrayWithRange:NSMakeRange(0, nItems)];
    }
    return resultArray;
}

-(void)reloadPagerTabStripView
{
    _isReload = YES;
    self.isProgressiveIndicator = (rand() % 2 == 0);
    self.isElasticIndicatorLimit = (rand() % 2 == 0);
    [super reloadPagerTabStripView];
}

@end
