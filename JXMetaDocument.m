//
//  JXMetaDocument.m
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//

#import "JXMetaDocument.h"

#import "JXExtendedFileAttributes.h"


NSString * const	MetadataWindowRectKey		= @"de.geheimwerk.metadata.document-window-frame";


@implementation JXMetaDocument

- (id)init
{
	self = [super init];
	
	if (self) {
        _fileMetadata = [[NSMutableDictionary dictionary] retain];
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

	NSData *data = [extendedFileAttributes dataForKey:MetadataWindowRectKey];
	
	_windowFrameDescription = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
    return YES;
}

- (BOOL)saveMetadataJXToURL:(NSURL *)url;
{
    _windowFrameDescription = [self.windowForMetadataJX stringWithSavedFrame];
	if (_windowFrameDescription == nil)  return NO;
	
	JXExtendedFileAttributes *extendedFileAttributes = [[JXExtendedFileAttributes alloc] initWithURL:url];
	
	NSData *data = [_windowFrameDescription dataUsingEncoding:NSUTF8StringEncoding];
    
	return [extendedFileAttributes setData:data forKey:MetadataWindowRectKey];
}

#pragma mark -
#pragma mark Overrides

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	[self readMetadataJXForURL:(NSURL *)absoluteURL];
	
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
