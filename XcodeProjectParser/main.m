//
//  main.m
//  XcodeProjectParser
//
//  Created by William Kent on 5/16/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCObjectRegistry.h"

static void usage(void) {
    fprintf(stderr, "usage: %s project.pbxproj\n", getprogname());
    fprintf(stderr, "Parses and prints the contents of each named pbxproj file\n");
    exit(1);
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "--help") == 0) usage();
            
            NSError *error;
            NSString *text = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:argv[i]] encoding:NSUTF8StringEncoding error:&error];
            if (text == nil) {
                fprintf(stderr, "Could not read '%s': %s\n", argv[i], error.description.UTF8String);
                continue;
            }
            
            printf("// %s\n", argv[i]);
            XCObjectRegistry *registry = [XCObjectRegistry objectRegistryWithXcodePBXProjectText:text];
            printf("%s\n", registry.projectPropertyList.description.UTF8String);
        }
    }
    
    return 0;
}
