//
//  CityModel.h
//  qiqi-tab
//
//  Created by Aaron on 6/2/16.
//  Copyright © 2016 whatever. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (strong, nonatomic) NSString *name, *pinyin, *shortname;

- (instancetype)initWithData:(NSString *)name
                      pinyin:(NSString *)pinyin
                   shortname:(NSString *)shortname;

+ (NSArray *) grouped;
+ (NSArray *) indices;
+ (NSArray *) all;

@end
