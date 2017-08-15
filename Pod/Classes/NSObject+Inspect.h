//
//  NSObject+Inspect.h
//  GDInspect
//
//  Created by Георгий Малюков on 28.07.17.
//  Copyright © 2017 Georgiy Malyukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDObjectProperty : NSObject

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) Class    type;
@property (readonly, nonatomic) NSString *typeString;

#pragma mark - Root

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithPropertyName:(NSString *)name type:(NSString *)type;

@end


@interface NSObject (Inspect)

#pragma mark - Inspecting

- (NSDictionary *)getClassProperties;
- (NSDictionary *)getClassPropertiesWithBaseClass:(Class)baseClass;
- (NSArray<GDObjectProperty *> *)getClassPropertiesSorted;
- (NSArray<GDObjectProperty *> *)getClassPropertiesSortedWithBaseClass:(Class)baseClass;
+ (NSArray<Class> *)subclassesOfClass:(Class)aClass;

@end
