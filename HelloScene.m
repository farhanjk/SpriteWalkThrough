//
//  HelloScene.m
//  SpriteWalkThrough
//
//  Created by Farhan Khan on 2013-07-09.
//  Copyright (c) 2013 Farhan Khan. All rights reserved.
//

#import "HelloScene.h"

@interface HelloScene()
@property BOOL contentCreated;
@end

@implementation HelloScene


-(void) didMoveToView:(SKView *)view
{
        if(!self.contentCreated)
        {
            [self createSceneContents];
            self.contentCreated = YES;
        }
}

-(void) createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    [self addChild:[self newHelloNode]];
}


-(SKLabelNode*) newHelloNode
{
    SKLabelNode* helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello, World!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return helloNode;
}

@end
