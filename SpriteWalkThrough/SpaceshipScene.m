//
//  SpaceshipScene.m
//  SpriteWalkThrough
//
//  Created by Farhan Khan on 2013-07-09.
//  Copyright (c) 2013 Farhan Khan. All rights reserved.
//

#import "SpaceshipScene.h"

@interface SpaceshipScene()

@property BOOL contentCreated;

@end

@implementation SpaceshipScene


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
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:spaceship];
}

-(SKSpriteNode*) newSpaceship
{
    SKSpriteNode* hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    SKAction* hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100.0 y:50.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100.0 y:-50 duration:1.0]
                                           ]];
    
    [hull runAction:[SKAction repeatActionForever:hover]];
    
    SKSpriteNode* light1 = [self newLight];
    SKSpriteNode* light2 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light1];
    [hull addChild:light2];
    
    return hull;
}

-(SKSpriteNode*) newLight
{
    SKSpriteNode* light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];
    
    SKAction* blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]
                                           ]];
    SKAction* blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever completion:nil];
    return light;
}

@end
