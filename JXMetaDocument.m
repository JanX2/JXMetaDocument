//
//  JXMetaDocument.m
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//

#import "JXMetaDocument.h"


@implementation JXMetaDocument

- (id)init
{
	self = [super init];
	
	if (self) {
        _fileMetadata = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	self.fileMetadata = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark Utilities

- (NSWindow *)windowForMetadataJX;
{
	NSArray *windowControllers = [self windowControllers];
	
	if (windowControllers.count > 0) {
		NSWindowController *windowController = [windowControllers objectAtIndex:0];
		NSWindow *window = [windowController window];
		return window;
	}
	else {
		return nil;
	}
}


#pragma mark -
#pragma mark Metadata

- (BOOL)readMetadataJXForURL:(NSURL *)url;
{
	JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];

	NSArray *metaKeyAndTypeArray = [self metadataKeyAndTypeArray];
	for (JXMetaKeyAndType* keyAndType in metaKeyAndTypeArray) {
		NSString *key = keyAndType.key;
		id value = [extendedFileAttributes objectForKey:key ofType:keyAndType.type];
		if (value != nil) {
			[_fileMetadata setObject:value forKey:key];
		}
		else {
			[_fileMetadata removeObjectForKey:key];
		}
	}
	
	[extendedFileAttributes release];
	
    return YES;
}

- (BOOL)saveMetadataJXToURL:(NSURL *)url;
{
	BOOL success = YES;
	
	JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];
	
	NSArray *metaKeyAndTypeArray = [self metadataKeyAndTypeArray];
	for (JXMetaKeyAndType* keyAndType in metaKeyAndTypeArray) {
		NSString *key = keyAndType.key;
		id value = [_fileMetadata objectForKey:key];
		if (value != nil) {
			if ([extendedFileAttributes setObject:value ofType:keyAndType.type forKey:key] == NO) {
				success = NO;
			}
		}
		
	}
	
	[extendedFileAttributes release];
	
	return success;
}

- (NSArray *)metadataKeyAndTypeArray;
{
	return [NSArray array];
}


- (BOOL)shouldLoadMetadata;
{
	return YES;
}

- (void)didLoadMetadataWithResult:(BOOL)success;
{
	return;
}

#pragma mark -
#pragma mark Overrides

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	if ([self shouldLoadMetadata]) {
		BOOL success = [self readMetadataJXForURL:(NSURL *)absoluteURL];
		[self didLoadMetadataWithResult:success];
	}
	
	return [super readFromURL:absoluteURL ofType:typeName error:outError];
}

- (BOOL)writeSafelyToURL:(NSURL *)url ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError
{
	BOOL result = [super writeSafelyToURL:url ofType:typeName forSaveOperation:saveOperation error:outError];
	
	if (result) {
		/*result = */[self saveMetadataJXToURL:url]; // Metadata is not supposed to be critical. Thus we ignore any metadata saving errors.
	}
	
	return result;
}

@end
