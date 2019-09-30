//
//  JXMetaDocument.h
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//  Copyright 2013-2016 Jan Weiß. Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import <Cocoa/Cocoa.h>

#import "JXExtendedFileAttributes.h"
#import "JXMetaKeyAndType.h"


@interface JXMetaDocument : NSDocument {
	NSMutableDictionary *_fileMetadata;
	BOOL _saveJustTheMetadataIfDocumentHasNoChanges;
}

@property (nonatomic, readwrite, strong) NSMutableDictionary *fileMetadata; // NOTE: For internal/category use only!
@property (nonatomic, readwrite, assign) BOOL saveJustTheMetadataIfDocumentHasNoChanges;

@property (nonatomic, readonly, strong) NSWindow *windowForMetadataJX;

- (BOOL)readMetadataJXForURL:(NSURL *)url;
- (BOOL)saveMetadataJXToURL:(NSURL *)url;

// Override this in your subclass to return your own JXMetaKeyAndType array.
@property (nonatomic, readonly, copy) NSArray *metadataKeyAndTypeArray;

// Optionally, override these in your subclass for more fine-grained control.
// Some of these may do nothing in the current implementation. This may change.
// So be sure to call them on super!
- (BOOL)shouldLoadMetadataForType:(NSString *)typeName;
- (void)didLoadMetadataWithResult:(BOOL)success;
- (void)skippedLoadingMetadata;

- (BOOL)shouldSaveMetadataForType:(NSString *)typeName
					saveOperation:(NSSaveOperationType)saveOperation;
- (void)willSaveMetadata;
- (void)didSaveMetadataWithResult:(BOOL)success;
- (void)skippedSavingMetadata;

@end
