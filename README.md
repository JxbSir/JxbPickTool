# JxbPickTool
##封装UIPickerView, 一行代码搞定一个选择器

```
一个工程里面可能会用到很多的UIPickerView，例如：城市选择、人数选择、数值、男女，等等，
一般都会很相应数个的UIPickerView，然后都有各自的逻辑代码，其实这样非常冗余。
所以笔者写一个公用逻辑，支持自行分装逻辑，支持字典与数组形式构造，非常方便滴~~~
```

#CocoaPods
```pod 'JxbPickTool'```

#代码
方式1：城市选择
```objectivec
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
```

方式2：自定义字典，支持自定义对象，不过自定义对象的话需要注意使用：displayProperty
```objectivec
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
```

方式3：自定义数组，每个列之间是没有关联的，支持自定义对象，不过自定义对象的话需要注意使用：displayProperty
```objectivec
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
```
