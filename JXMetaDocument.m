//
//  JXMetaDocument.m
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//  Copyright 2013-2019 Jan Weiß. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "JXMetaDocument.h"


// TODO: Consider implementing using NSDocument’s -fileAttributesToWriteToURL:ofType:forSaveOperation:originalContentsURL:error: or -writeToURL:ofType:forSaveOperation:originalContentsURL:error:.

@implementation JXMetaDocument

- (instancetype)init
{
	self = [super init];
	
	if (self) {
        _fileMetadata = [[NSMutableDictionary alloc] init];
		
		_saveJustTheMetadataIfDocumentHasNoChanges = NO;
	}
	
	return self;
}


#pragma mark -
#pragma mark Utilities

- (NSWindow *)windowForMetadataJX;
{
	NSArray *windowControllers = self.windowControllers;
	
	if (windowControllers.count > 0) {
		NSWindowController *windowController = windowControllers[0];
		NSWindow *window = windowController.window;
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
	[self performSynchronousFileAccessUsingBlock:^{
		JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];
		
		NSArray *metaKeyAndTypeArray = [self metadataKeyAndTypeArray];
		for (JXMetaKeyAndType *keyAndType in metaKeyAndTypeArray) {
			NSString *key = keyAndType.key;
			id value = [extendedFileAttributes objectForKey:key
													 ofType:keyAndType.type];
			if (value != nil) {
				_fileMetadata[key] = value;
			}
			else {
				[_fileMetadata removeObjectForKey:key];
			}
		}
	}];
	
    return YES;
}

- (BOOL)saveMetadataJXToURL:(NSURL *)url;
{
	__block BOOL success = YES;
	
	{
		JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];
		
		NSArray *metaKeyAndTypeArray = [self metadataKeyAndTypeArray];
		for (JXMetaKeyAndType *keyAndType in metaKeyAndTypeArray) {
			NSString *key = keyAndType.key;
			id value = _fileMetadata[key];
			if (value != nil) {
				if ([extendedFileAttributes setObject:value
											   ofType:keyAndType.type
											   forKey:key] == NO) {
					success = NO;
					// We don’t break here, because we want to at least try to finish processing the other key-value pairs.
				}
			}
			
		}
	}
	
	return success;
}

- (NSArray *)metadataKeyAndTypeArray;
{
	return @[];
}


- (BOOL)shouldLoadMetadataForType:(NSString *)typeName;
{
	return YES;
}

- (void)didLoadMetadataWithResult:(BOOL)success;
{
	return;
}

- (void)skippedLoadingMetadata;
{
	return;
}

- (BOOL)shouldSaveMetadataForType:(NSString *)typeName
					saveOperation:(NSSaveOperationType)saveOperation;
{
	// Don’t save metadata for file exports.
	return (saveOperation != NSSaveToOperation);
}

- (void)willSaveMetadata;
{
	return;
}

- (void)didSaveMetadataWithResult:(BOOL)success;
{
	return;
}

- (void)skippedSavingMetadata;
{
	return;
}

#pragma mark -
#pragma mark Overrides

- (BOOL)readFromURL:(NSURL *)absoluteURL
			 ofType:(NSString *)typeName
			  error:(NSError **)outError
{
	if ([self shouldLoadMetadataForType:typeName]) {
		BOOL success = [self readMetadataJXForURL:(NSURL *)absoluteURL];
		[self didLoadMetadataWithResult:success];
	}
	else {
		[self skippedLoadingMetadata];
	}
	
	return [super readFromURL:absoluteURL
					   ofType:typeName
						error:outError];
}

- (BOOL)writeSafelyToURL:(NSURL *)url
				  ofType:(NSString *)typeName
		forSaveOperation:(NSSaveOperationType)saveOperation
				   error:(NSError **)outError
{
	BOOL documentIsEdited = self.isDocumentEdited;
	BOOL success;
	
	// Skip saving: if the document was not changed, skipping is not disabled, and we are instructed to save in-place.
	BOOL skipSaving = (documentIsEdited == NO &&
					   _saveJustTheMetadataIfDocumentHasNoChanges &&
					   (saveOperation == NSSaveOperation ||
						saveOperation == NSAutosaveInPlaceOperation));
	
	if (skipSaving) {
		success = YES;
	}
	else {
		success = [super writeSafelyToURL:url ofType:typeName forSaveOperation:saveOperation error:outError];
	}
	
	if (success) {
		if ([self shouldSaveMetadataForType:typeName
							  saveOperation:saveOperation]) {
			[self willSaveMetadata];
			BOOL didSaveMetadata = [self saveMetadataJXToURL:url]; // Metadata is not supposed to be critical. Thus we ignore any metadata saving errors.
			[self didSaveMetadataWithResult:didSaveMetadata];
		}
		else {
			[self skippedSavingMetadata];
		}
	}
	
	return success;
}

@end
