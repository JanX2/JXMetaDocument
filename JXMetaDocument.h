//
//  JXMetaDocument.h
//  CSV Converter
//
//  Created by Jan on 03.08.13.
//
//

#import <Cocoa/Cocoa.h>

@class JXExtendedFileAttributes;


@interface JXMetaDocument : NSDocument {
	NSMutableDictionary *_fileMetadata;
	NSString *_windowFrameDescription;
}

@property (nonatomic, readwrite, strong) NSMutableDictionary *fileMetadata;

- (NSWindow *)windowForMetadataJX;

- (BOOL)readMetadataJXForURL:(NSURL *)url;
- (BOOL)saveMetadataJXToURL:(NSURL *)url;

@end
