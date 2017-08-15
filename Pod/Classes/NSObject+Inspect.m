//
//  NSObject+Inspect.m
//  GDInspect
//
//  Created by Георгий Малюков on 28.07.17.
//  Copyright © 2017 Georgiy Malyukov. All rights reserved.
//

#import "NSObject+Inspect.h"
#import <objc/runtime.h>

@implementation GDObjectProperty

#pragma mark - Root

- (instancetype)initWithPropertyName:(NSString *)name type:(NSString *)type {
    self = [super init];
    if (self) {
        _name = [name copy];
        _typeString = [type copy];
        _type = NSClassFromString(_typeString);
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@: %@", self.name, self.typeString];
}

@end


@implementation NSObject (Inspect)

#pragma mark - Inspecting

- (NSDictionary *)getClassProperties {
    return [self getClassPropertiesWithBaseClass:[NSObject class]];
}

- (NSDictionary *)getClassPropertiesWithBaseClass:(Class)baseClass {
    return [[self class] classPropsForClassHierarchy:[self class]
                                        onDictionary:[@{} mutableCopy]
                                           baseClass:baseClass];
}

- (NSArray<GDObjectProperty *> *)getClassPropertiesSorted {
    return [self getClassPropertiesSortedWithBaseClass:[NSObject class]];
}

- (NSArray<GDObjectProperty *> *)getClassPropertiesSortedWithBaseClass:(Class)baseClass {
    NSMutableArray *list = [NSMutableArray new];
    NSDictionary *props = [self getClassPropertiesWithBaseClass:baseClass];
    for (NSString *propertyName in props.allKeys) {
        GDObjectProperty *property = [[GDObjectProperty alloc]
                                       initWithPropertyName:propertyName
                                       type:props[propertyName]];
        [list addObject:property];
    }
    return [list sortedArrayUsingComparator:^NSComparisonResult(GDObjectProperty *obj1, GDObjectProperty *obj2) {
        return [obj1.name compare:obj2.name];
    }];
}

+ (NSArray<Class> *)subclassesOfClass:(Class)aClass {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    // retrieve all subclasses
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = classes[i];
        do {
            superClass = class_getSuperclass(superClass);
        }
        while(superClass && superClass != aClass);
        // add non-nil
        if (superClass != nil) {
            [result addObject:classes[i]];
        }
    }
    free(classes);
    return result;
}

+ (const char *)getPropertyType:(objc_property_t)property {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1
                                                      length:strlen(attribute) - 1
                                                    encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

+ (NSDictionary *)classPropsForClassHierarchy:(Class)klass onDictionary:(NSMutableDictionary *)results baseClass:(Class)baseClass {
    if (klass == NULL) {
        return nil;
    }
    //stop if we reach the base class
    if (klass == baseClass || klass == [NSObject class]) {
        // exclude potentially overridden NSObject properties
        [results removeObjectForKey:@"debugDescription"];
        [results removeObjectForKey:@"description"];
        [results removeObjectForKey:@"hash"];
        [results removeObjectForKey:@"superclass"];
        // return combined results
        return [NSDictionary dictionaryWithDictionary:results];
    }
    else {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(klass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if(propName) {
                const char *propType = [[self class] getPropertyType:property];
                NSString *propertyName = [NSString stringWithUTF8String:propName];
                NSString *propertyType = [NSString stringWithUTF8String:propType];
                [results setObject:propertyType forKey:propertyName];
            }
        }
        free(properties);
        //go for the superclass
        return [NSObject classPropsForClassHierarchy:[klass superclass] onDictionary:results baseClass:baseClass];
    }
}

@end
