//
//  AGViewController.m
//  AGPullView
//
//  Created by Aleksey Getman on 07/15/2016.
//  Copyright (c) 2016 Aleksey Getman. All rights reserved.
//

#import "AGViewController.h"
#import "AGPullViewConfigurer.h"

@interface AGViewController () <AGConfigurerDelegate, UITableViewDataSource>

@property (nonatomic, strong) AGPullViewConfigurer *configurer;

@end

@implementation AGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //AGPullView configuration
    self.configurer = [AGPullViewConfigurer new];
    [self.configurer setupPullViewForSuperview:self.view colorScheme:ColorSchemeTypeGrayTransparent];
    self.configurer.percentOfFilling = @85;
    self.configurer.delegate = self;
    self.configurer.needBounceEffect = true;
    self.configurer.animationDuration = @0.3;
    self.configurer.enableShowingWithTouch = true;
    self.configurer.enableHidingWithTouch = false;
    [self.configurer enableBlurEffectWithBlurStyle:UIBlurEffectStyleLight];
    
    //Test UITableView
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    //Filling whole AGPullView with test UITableView
    [self.configurer fullfillContentViewWithView:table];
}

//For correct working of layout in early versions of iOS 10
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.configurer layoutPullView];
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
    [self.configurer handleTouchesBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.configurer handleTouchesMoved:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.configurer handleTouchesEnded:touches];
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
    self.configurer.blurStyle = randomBlur;
    
    NSInteger randomColorScheme = arc4random_uniform(6);
    self.configurer.colorSchemeType = randomColorScheme;
}

@end
