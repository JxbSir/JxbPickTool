//
//  JxbPickTool.m
//  Axiba
//
//  Created by Peter on 16/6/15.
//  Copyright © 2016年 https://github.com/JxbSir. All rights reserved.
//

#import "JxbPickTool.h"

#define kTPScreenWidth          [UIScreen mainScreen].bounds.size.width
#define kTPScreenHeight         [UIScreen mainScreen].bounds.size.height

#define heightOfPickView        200.0
#define heightOfOpt             50.0

@implementation JxbPickItem

- (instancetype _Nonnull)initWithDictionary:(NSDictionary* _Nonnull )dic displayProperty:(NSString* _Nullable) displayProperty {
    JxbPickItem* item = [[JxbPickItem alloc] init];
    item.selectIndex = 0;
    item.columnIndex = 1;
    [self p_parseDictionary:dic item:item displayProperty:displayProperty];
    return item;
}

- (instancetype _Nonnull)initWithArray:(NSArray* _Nonnull)array displayProperty:(NSString* _Nullable) displayProperty {
    JxbPickItem* item  =[[JxbPickItem alloc] init];
    item.selectIndex = 0;
    item.columnIndex = 1;
    for (NSInteger i = 0; i < array.count; i++) {
        id arr = array[i];
        if (![arr isKindOfClass:[NSArray class]]) {
            NSAssert(false, @"array参数每一项都应为NSArray.");
            break;
        }
        [self p_addPrevItem:item column:i arr:arr displayProperty:displayProperty];
    }
    return item;
}

#pragma mark - private
- (void)p_addPrevItem:(JxbPickItem*)item column:(NSInteger)column arr:(NSArray*)arr displayProperty:(NSString* _Nullable) displayProperty {
    if (column+1 == item.columnIndex) {
        [self p_parseArray:arr item:item displayProperty:displayProperty];
    }
    else {
        for (JxbPickItem* obj in item.items) {
            [self p_addPrevItem:obj column:column arr:arr displayProperty:displayProperty];
        }
    }
}

- (void)p_parseArray:(NSArray*)array item:(JxbPickItem*)item displayProperty:(NSString* _Nullable) displayProperty {
    NSMutableArray* arr = [NSMutableArray array];
    for (id obj in array) {
        JxbPickItem* item2 = [[JxbPickItem alloc] init];
        item2.selectIndex = 0;
        item2.columnIndex = item.columnIndex + 1;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [self p_parseDictionary:obj item:item2 displayProperty:displayProperty];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            [self p_parseArray:obj item:item2 displayProperty:displayProperty];
        }
        else {
            if ([obj isKindOfClass:[NSString class]]) {
                item2.placeHolder = obj;
            }
            else {
                item2.placeHolder = [obj valueForKey:displayProperty];
            }
            item2.originData = obj;
            [arr addObject:item2];
        }
    }
    item.items = arr;

}

- (void)p_parseDictionary:(NSDictionary*)dic item:(JxbPickItem*)item displayProperty:(NSString* _Nullable) displayProperty {
    NSMutableArray* arr = [NSMutableArray array];
    for (id key in dic.allKeys) {
        JxbPickItem* item1 = [[JxbPickItem alloc] init];
        item1.selectIndex = 0;
        item1.columnIndex = item.columnIndex + 1;
        if ([key isKindOfClass:[NSString class]]) {
            item1.placeHolder = key;
        }
        else {
            item1.placeHolder = [key valueForKey:displayProperty];
        }

        item1.originData = key;

        id value = dic[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self p_parseDictionary:value item:item1 displayProperty:displayProperty];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            [self p_parseArray:value item:item1 displayProperty:displayProperty];
        }
        [arr addObject:item1];
    }
    item.items = arr;
}

@end

@interface JxbPickTool()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) BOOL              bAnimated;
@property (nonatomic, strong) UIView            *viewOfOpt;
@property (nonatomic, strong) UILabel           *lblTitle;
@property (nonatomic, strong) UIPickerView      *pickView;
@end

@implementation JxbPickTool

- (id)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [self addGestureRecognizer:tap];
        
        self.viewOfOpt = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, heightOfOpt)];
        self.viewOfOpt.backgroundColor = [UIColor whiteColor];
        [self.viewOfOpt addGestureRecognizer:[UITapGestureRecognizer new]];
        [self addSubview:self.viewOfOpt];
        
        UIView* vLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightOfOpt-1, frame.size.width, 1)];
        vLine.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1];
        [self.viewOfOpt addSubview:vLine];

        UIButton* btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, heightOfOpt)];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnCancel addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.viewOfOpt addSubview:btnCancel];
        
        UIButton* btnOK = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 70, 0, 60, heightOfOpt)];
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnOK addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [self.viewOfOpt addSubview:btnOK];
        
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        self.lblTitle.text = self.placeholder;
        self.lblTitle.textColor = [UIColor lightGrayColor];
        self.lblTitle.font = [UIFont systemFontOfSize:13];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        [self.viewOfOpt addSubview:self.lblTitle];
        
        
        self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kTPScreenHeight, frame.size.width, heightOfPickView)];
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.pickView.backgroundColor =  [UIColor whiteColor];
        [self addSubview:self.pickView];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.lblTitle.text = placeholder;
}

- (void)closeAction {
    [self hide:self.bAnimated];
}

- (void)okAction {
    if (self.block != NULL) {
        NSMutableArray *arr = [NSMutableArray array];
        [self getSelectedDatas:self.itemData arr:arr];
        self.block(arr);
    }
    [self hide:self.bAnimated];
}

#pragma mark - 递归获取参数
- (NSInteger)getColumnCount:(JxbPickItem*)item count:(NSInteger)count {
    if (item.columnIndex > 0)
        count++;
    JxbPickItem* selectItem = item.items[item.selectIndex];
    if (selectItem.items.count > 0)
        return [self getColumnCount:selectItem count:count];
    return count;
}

- (NSArray*)getRows:(JxbPickItem*)item column:(NSInteger)column {
    if (column + 1 == item.columnIndex) {
        return item.items;
    }
    return [self getRows:item.items[item.selectIndex] column:column];
}

- (JxbPickItem*)getItemForRowColumn:(JxbPickItem*)item column:(NSInteger)column row:(NSInteger)row {
    if (column + 1 == item.columnIndex) {
        return item.items[row];
    }
    return [self getItemForRowColumn:item.items[item.selectIndex] column:column row:row];
}

- (void)setSelectedChange:(JxbPickItem*)item column:(NSInteger)column row:(NSInteger)row {
    if (column == item.columnIndex) {
        item.selectIndex = row;
        return;
    }
    [self setSelectedChange:item.items[item.selectIndex] column:column row:row];
}

- (void)getSelectedDatas:(JxbPickItem*)item arr:(NSMutableArray*)arr {
    JxbPickItem* currentItem = item.items[item.selectIndex];
    [arr addObject:currentItem.originData];
    if (currentItem.items.count > 0) {
        [self getSelectedDatas:currentItem arr:arr];
    }
}

- (void)setSelectIndex:(JxbPickItem*)item {
    if (item.items.count > 0) {
        [self.pickView selectRow:item.selectIndex inComponent:item.columnIndex-1 animated:YES];
        [self setSelectIndex:item.items[item.selectIndex]];
    }
}

#pragma mark- 设置数据
//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger num = [self getColumnCount:self.itemData count:0];
    return num;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = [[self getRows:self.itemData column:component] count];
    return num;
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    JxbPickItem* item = [self getItemForRowColumn:self.itemData column:component row:row];
    return item.placeHolder;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setSelectedChange:self.itemData column:component+1 row:row];
    [pickerView reloadAllComponents];
    [self setSelectIndex:self.itemData];
}

- (UIViewController* )rootViewController {
    UIViewController* root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return root;
}
- (void)show:(BOOL)bAnimated {
    __weak typeof (self) wSelf = self;
    self.bAnimated = bAnimated;
    [[[self rootViewController] view] addSubview:self];
    void (^block)(void) = ^{
        CGFloat y = kTPScreenHeight - heightOfPickView - heightOfOpt;
        wSelf.viewOfOpt.frame = CGRectMake(wSelf.viewOfOpt.frame.origin.x, y, wSelf.viewOfOpt.frame.size.width, wSelf.viewOfOpt.frame.size.height);
        wSelf.pickView.frame = CGRectMake(wSelf.pickView.frame.origin.x, kTPScreenHeight - heightOfPickView, wSelf.pickView.frame.size.width, wSelf.pickView.frame.size.height);
        wSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [wSelf.pickView layoutIfNeeded];
        [wSelf.viewOfOpt layoutIfNeeded];
    };
    if (self.bAnimated) {
        [UIView animateWithDuration:0.35 animations:block];
    }
    else {
        block();
    }
}

- (void)hide:(BOOL)bAnimated {
    __weak typeof (self) wSelf = self;
    void (^block)(void) = ^{
        wSelf.viewOfOpt.frame = CGRectMake(wSelf.viewOfOpt.frame.origin.x, kTPScreenHeight, wSelf.viewOfOpt.frame.size.width, wSelf.viewOfOpt.frame.size.height);
        wSelf.pickView.frame = CGRectMake(wSelf.pickView.frame.origin.x, kTPScreenHeight, wSelf.pickView.frame.size.width, wSelf.pickView.frame.size.height);
        wSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    };
    if (self.bAnimated) {
        [UIView animateWithDuration:0.35 animations:block completion:^(BOOL finished) {
            [wSelf removeFromSuperview];
        }];
    }
    else {
        block();
        [wSelf removeFromSuperview];
    }
}

@end
