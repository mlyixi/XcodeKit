//
//  main.m
//  XcodeProjectParser
//
//  Created by William Kent on 5/16/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XcodeKit.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSString *filePath = @"/Users/mlyixi/Documents/Test/Test.xcodeproj";
        
        @try {
            XCObjectRegistry *registry = [XCObjectRegistry objectRegistryWithXcodeProject:filePath];
            
            // modify the buildSetting
            for (XCTarget *target in registry.project.targets) {
                for (XCConfiguration *config in target.configurationList.configurations) {
                    NSDictionary *dict=[NSDictionary dictionaryWithObject:@"" forKey:XCConfigurationPropertyCodeSignIdentity];
                    [config.buildSettings addEntriesFromDictionary:dict];
                    [registry setResourceObject:config];
                }
                
            }
            XCRunScriptBuildPhase *rsb=[XCRunScriptBuildPhase createRunScriptBuildPhaseWithScript:@"echo hello" inRegistry:registry];
            for (XCTarget *target in registry.project.targets) {
                [target addBuildPhase:rsb];
                [registry setResourceObject:target];
            }
            
            [registry save];
            
            for (XCTarget *target in registry.project.targets) {
                for (XCBuildPhase *bp in target.buildPhases) {
                    if ([bp.type isEqualToString: @"PBXShellScriptBuildPhase"]) {
                        [target removeBuildPhase:bp];
                    } 
                }
            }
            
            [registry save];

        } @catch (NSException *exception) {
            NSLog(@"Could not parse pbxproj: %@",exception.description);
        }
    }
    
    return 0;
}
