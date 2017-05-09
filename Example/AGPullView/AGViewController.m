//
//  AGViewController.m
//  AGPullView
//
//  Created by Aleksey Getman on 07/15/2016.
//  Copyright (c) 2016 Aleksey Getman. All rights reserved.
//

#import "AGViewController.h"
#import "AGPullViewconfigurator.h"

@interface AGViewController () <AGConfiguratorDelegate, UITableViewDataSource>

@property (nonatomic, strong) AGPullViewConfigurator *configurator;

@end

@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //AGPullView configuration
    self.configurator = [AGPullViewConfigurator new];
    [self.configurator setupPullViewForSuperview:self.view colorScheme:ColorSchemeTypeGrayTransparent];
    self.configurator.percentOfFilling = @100;
    self.configurator.delegate = self;
    self.configurator.needBounceEffect = true;
    self.configurator.animationDuration = @0.3;
    self.configurator.enableShowingWithTouch = true;
    self.configurator.enableHidingWithTouch = false;
    [self.configurator enableBlurEffectWithBlurStyle:UIBlurEffectStyleLight];
    
    //Test UITableView
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    //Filling whole AGPullView with test UITableView
    [self.configurator fullfillContentViewWithView:table];
}

//For correct working of layout in early versions of iOS 10
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.configurator layoutPullView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.configurator showAnimated:YES forPercent:30];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.configurator showAnimated:YES forPercent:50];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.configurator showAnimated:YES forPercent:100];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = @"Test";
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.configurator handleTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.configurator handleTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.configurator handleTouchesEnded:touches];
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

- (IBAction)openSwiftController:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SwiftExample" bundle:[NSBundle mainBundle]];
    UIViewController *swiftVC = [storyBoard instantiateViewControllerWithIdentifier:@"exampleSwiftVC"];
    [self presentViewController:swiftVC animated:YES completion:nil];
}

- (IBAction)changeAppearenceToRandom:(id)sender {
    NSInteger randomBlur = arc4random_uniform(2);
    self.configurator.blurStyle = randomBlur;
    
    NSInteger randomColorScheme = arc4random_uniform(6);
    self.configurator.colorSchemeType = randomColorScheme;
}

@end
