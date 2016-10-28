//
//  Global.h
//  练习一
//
//  Created by 周君 on 16/8/12.
//  Copyright © 2016年 周君. All rights reserved.
//

#ifndef Global_h
#define Global_h
#ifdef __OBJC__

// 配置pch： buildSetting -> prefix ->


/* pch里面的所有内容都是共享，每个文件都会共有:
 作用:
 1.存放一些公用的宏
 2.存放一些公用的头文件
 3.自定义Log
 */

/** 屏幕的宽**/
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
/** 屏幕的高**/
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

/** 取十六进制颜色**/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 添加观察者的自动提示宏定义**/
#define KeyPath(_object,keyPath) @(((_object.keyPath), #keyPath))
/** masonry的必要头文件**/
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS



#define SaveData(value, key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define GetData(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]

// 宏里面可变参数：...
// 函数中可变参数: __VA_ARGS__

#ifdef DEBUG // 调试阶段
#define ZJLog(...)  NSLog(__VA_ARGS__)

#else // 发布阶段

#define ZJLog(...)

#endif

#endif

#endif /* Global_h */
