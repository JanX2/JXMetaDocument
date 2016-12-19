//
//  JXMetaDocument.h
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//

#import <Cocoa/Cocoa.h>

#import "JXExtendedFileAttributes.h"
#import "JXMetaKeyAndType.h"


@interface JXMetaDocument : NSDocument {
	NSMutableDictionary *_fileMetadata;
	BOOL _saveJustTheMetadataIfDocumentHasNoChanges;
}

@property (nonatomic, readwrite, strong) NSMutableDictionary *fileMetadata;
@property (nonatomic, readwrite, assign) BOOL saveJustTheMetadataIfDocumentHasNoChanges;

- (NSWindow *)windowForMetadataJX;

- (BOOL)readMetadataJXForURL:(NSURL *)url;
- (BOOL)saveMetadataJXToURL:(NSURL *)url;

// Override this in your subclass to return your own JXMetaKeyAndType array.
- (NSArray *)metadataKeyAndTypeArray;

@end
