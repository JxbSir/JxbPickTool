//
//  JxbPickTool.h
//  Axiba
//
//  Created by Peter on 16/6/15.
//  Copyright © 2016年 https://github.com/JxbSir. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JxbPickSelectBlock)(NSArray* _Nonnull arrOfSelected);

@interface JxbPickItem : NSObject
@property (nonatomic, assign)           NSInteger               columnIndex;
@property (nonatomic, assign)           NSInteger               selectIndex;
@property (nonatomic, strong, nonnull)  NSString                *placeHolder;
@property (nonatomic, strong, nonnull)  id                      originData;
@property (nonatomic, strong, nullable) NSArray<JxbPickItem*>   *items;

/**
 *  构造JxbPickItem对象(用于每列有对应关系的)
 *
 *  @param dic             dic源数据
 *  @param displayProperty Dictionary的value并非为string是对象时，需要通过此属性获取显示text
 *
 *  @return JxbPickItem对象
 */
- (instancetype _Nonnull)initWithDictionary:(NSDictionary* _Nonnull )dic displayProperty:(NSString* _Nullable) displayProperty;

/**
 *  构造JxbPickItem对象(用于每列都没有对应关系的)
 *
 *  @param array          NSArray数据源，Count为列，它的子对象还是NSArray，Count是索引对应列的行数据
 *
 *  @return JxbPickItem对象
 */
- (instancetype _Nonnull)initWithArray:(NSArray* _Nonnull)array displayProperty:(NSString* _Nullable) displayProperty;
@end

@interface JxbPickTool : UIControl
@property (nonatomic, strong, nullable) NSString            *placeholder;
@property (nonatomic, strong, nonnull)  JxbPickItem         *itemData;
@property (nonatomic, copy  , nullable) JxbPickSelectBlock  block;

/**
 *  显示Picker
 *
 *  @param bAnimated 是否动画
 */
- (void)show:(BOOL)bAnimated;
@end
