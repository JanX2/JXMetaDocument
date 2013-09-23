//
//  JXMetaKeyAndType.m
//  CSV Converter
//
//  Created by Jan on 04.09.13.
//
//

#import "JXMetaKeyAndType.h"

@implementation JXMetaKeyAndType

- (id)initWithKey:(NSString *)key type:(JXExtendedFileAttributesValueTypes)type;
{
	self = [super init];
	
	if (self) {
		_key = [key copy];
		_type = type;
	}
	
	return self;
}

+ (id)objectWithKey:(NSString *)key type:(JXExtendedFileAttributesValueTypes)type;
{
	id result = [[[self class] alloc] initWithKey:key type:type];
	
	return result;
}

@end
