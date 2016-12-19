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

@property (nonatomic, readwrite, strong) NSMutableDictionary *fileMetadata;
@property (nonatomic, readwrite, assign) BOOL saveJustTheMetadataIfDocumentHasNoChanges;

- (NSWindow *)windowForMetadataJX;

- (BOOL)readMetadataJXForURL:(NSURL *)url;
- (BOOL)saveMetadataJXToURL:(NSURL *)url;

// Override this in your subclass to return your own JXMetaKeyAndType array.
- (NSArray *)metadataKeyAndTypeArray;

@end
