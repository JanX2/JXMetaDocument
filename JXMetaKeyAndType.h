//
//  JXMetaKeyAndType.h
//  CSV Converter
//
//  Created by Jan on 04.09.13.
//
//

#import <Foundation/Foundation.h>

#import "JXExtendedFileAttributes.h"

@interface JXMetaKeyAndType : NSObject

@property (nonatomic, readonly, strong) NSString *key;
@property (nonatomic, readonly) JXExtendedFileAttributesValueTypes type;

- (id)initWithKey:(NSString *)key type:(JXExtendedFileAttributesValueTypes)type;
+ (id)objectWithKey:(NSString *)key type:(JXExtendedFileAttributesValueTypes)type;

@end
