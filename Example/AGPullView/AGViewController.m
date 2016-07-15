//
//  AGViewController.m
//  AGPullView
//
//  Created by Aleksey Getman on 07/15/2016.
//  Copyright (c) 2016 Aleksey Getman. All rights reserved.
//

#import "AGViewController.h"
#import "AGPullViewConfigurer.h"
#import "AGConfigurerDelegate.h"

@interface AGViewController () <AGConfigurerDelegate, UITableViewDataSource>

@end

@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //AGPullView configuration
    AGPullViewConfigurer *configurer = [AGPullViewConfigurer configurer];
    [configurer setupPullViewForSuperview:self.view colorScheme:ColorSchemeTypeGrayTransparent];
    configurer.percentOfFilling = @85;
    configurer.delegate = self;
    configurer.needBounceEffect = true;
    configurer.animationDuration = @0.3;
    configurer.enableShowingWithTouch = true;
    configurer.enableHidingWithTouch = true;
    [configurer enableBlurEffectWithBlurStyle:UIBlurEffectStyleLight];
    
    //Test UITableView
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    //Filling whole AGPullView with test UITableView
    [configurer fullfillContentViewWithView:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"Test";
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[AGPullViewConfigurer configurer] handleTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[AGPullViewConfigurer configurer] handleTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[AGPullViewConfigurer configurer] handleTouchesEnded:touches];
}

- (void)didDragPullView:(AGPullView *)pullView withOpeningPercent:(float)openingPercent {
    NSLog(@"%f", openingPercent);
}

- (void)didShowPullView:(AGPullView *)pullView {
    NSLog(@"shown");
}

- (void)didHidePullView:(AGPullView *)pullView {
    NSLog(@"hidden");
}

- (void)didTouchToShowPullView:(AGPullView *)pullView {
    NSLog(@"touched to show");
}

- (void)didTouchToHidePullView:(AGPullView *)pullView {
    NSLog(@"touched to hide");
}

@end
