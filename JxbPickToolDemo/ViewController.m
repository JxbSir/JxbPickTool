//
//  ViewController.m
//  JxbPickToolDemo
//
//  Created by Peter on 16/6/17.
//  Copyright © 2016年 https://github.com/JxbSir. All rights reserved.
//

#import "ViewController.h"
#import "JxbPickTool.h"

@interface testClass : NSObject
@property (nonatomic, strong) NSString  *displayName;
@end

@implementation testClass
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton    *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 60, 200, 44)];
    [btn1 setTitle:@"城市Picker" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton    *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 120, 200, 44)];
    [btn2 setTitle:@"自定义字典Picker" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton    *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 200, 44)];
    [btn3 setTitle:@"自定义数组Picker" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor blueColor];
    [btn3 addTarget:self action:@selector(btn3Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
}

- (void)btn1Action {
    NSString* file = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:file];
    JxbPickItem* item = [[JxbPickItem alloc] initWithDictionary:dic displayProperty:@"displayName"];
    JxbPickTool* tool = [JxbPickTool new];
    tool.itemData = item;
    tool.block = ^(NSArray* arr) {
        NSLog(@"%@", arr);
    };
    [tool show:YES];
}

- (void)btn2Action {
    testClass* test = [testClass new];
    test.displayName = @"good";
    NSDictionary *dic = @{@"a":@[test],@"b":@[test],@"c":@[test]};
    JxbPickItem* item = [[JxbPickItem alloc] initWithDictionary:dic displayProperty:@"displayName"];
    JxbPickTool* tool = [JxbPickTool new];
    tool.itemData = item;
    tool.block = ^(NSArray* arr) {
        NSLog(@"%@", arr);
    };
    [tool show:YES];
}

- (void)btn3Action {
    NSArray* arr = @[@[@"a",@"b"],@[@"x",@"y",@"z"],@[@"1",@"2",@"3",@"4"]];
    JxbPickItem* item = [[JxbPickItem alloc] initWithArray:arr displayProperty:nil];
    JxbPickTool* tool = [JxbPickTool new];
    tool.itemData = item;
    tool.block = ^(NSArray* arr) {
        NSLog(@"%@", arr);
    };
    [tool show:YES];
}


@end
