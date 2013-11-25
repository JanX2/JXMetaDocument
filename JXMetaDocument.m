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
		
		_saveJustTheMetadataIfDocumentHasNoChanges = YES;
	}
	
	return self;
}


#pragma mark -
#pragma mark Utilities

- (NSWindow *)windowForMetadataJX;
{
	NSArray *windowControllers = [self windowControllers];
	
	if (windowControllers.count > 0) {
		NSWindowController *windowController = windowControllers[0];
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
			_fileMetadata[key] = value;
		}
		else {
			[_fileMetadata removeObjectForKey:key];
		}
	}
	
    return YES;
}

- (BOOL)saveMetadataJXToURL:(NSURL *)url;
{
	BOOL success = YES;
	
	JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];
	
	NSArray *metaKeyAndTypeArray = [self metadataKeyAndTypeArray];
	for (JXMetaKeyAndType* keyAndType in metaKeyAndTypeArray) {
		NSString *key = keyAndType.key;
		id value = _fileMetadata[key];
		if (value != nil) {
			if ([extendedFileAttributes setObject:value ofType:keyAndType.type forKey:key] == NO) {
				success = NO;
			}
		}
		
	}
	
	return success;
}

- (NSArray *)metadataKeyAndTypeArray;
{
	return @[];
}


- (BOOL)shouldLoadMetadata;
{
	return YES;
}

- (void)didLoadMetadataWithResult:(BOOL)success;
{
	return;
}

- (void)willSaveMetadata;
{
	return;
}

- (void)didSaveMetadataWithResult:(BOOL)success;
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
	BOOL documentIsEdited = self.isDocumentEdited;
	BOOL result;
	
	// Skip saving if skipping is not disabled, we save in-place and the document is edited.
	BOOL skipSaving = (!_saveJustTheMetadataIfDocumentHasNoChanges ||
					   (saveOperation != NSSaveOperation &&
						saveOperation != NSAutosaveInPlaceOperation) ||
					   documentIsEdited == YES);
	
	if (skipSaving == YES) {
		result = [super writeSafelyToURL:url ofType:typeName forSaveOperation:saveOperation error:outError];
	}
	else {
		result = YES;
	}
	
	if ((result == YES) &&
		(saveOperation != NSSaveToOperation) // Don’t save metadata for file exports.
		) {
		[self willSaveMetadata];
		BOOL success = [self saveMetadataJXToURL:url]; // Metadata is not supposed to be critical. Thus we ignore any metadata saving errors.
		[self didSaveMetadataWithResult:success];
	}
	
	return result;
}

@end
