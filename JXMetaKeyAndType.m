//
//  JXMetaKeyAndType.m
//  CSV Converter
//
//  Created by Jan on 04.09.13.
//
//  Copyright 2013-2016 Jan Weiß. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "JXMetaKeyAndType.h"

@implementation JXMetaKeyAndType

- (instancetype)initWithKey:(NSString *)key type:(JXExtendedFileAttributesValueTypes)type;
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
