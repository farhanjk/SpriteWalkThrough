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
@property (nonatomic)  SKTextureAtlas* playerTextureAtlas;
@property (nonatomic, strong) SKSpriteNode* spaceship;

@end

@implementation SpaceshipScene

@synthesize playerTextureAtlas=_playerTextureAtlas;
@synthesize spaceship = _spaceship;


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.view];
        //CGPoint charPos = self.spaceship.position;
        
        
        //CGFloat distance = sqrtf((touchPoint.x - charPos.x)* (touchPoint.x-charPos.x)
          //                       + (touchPoint.y - charPos.y)* (touchPoint.y-charPos.y));
        
        SKAction* moveToTouch = [SKAction moveTo:[self convertPointFromView:touchPoint] duration:1.0];
        [self.spaceship runAction:moveToTouch withKey:@"moveToTouch"];
    }];
}

-(SKTextureAtlas*) playerTextureAtlas
{
    if(!_playerTextureAtlas)
    {
        _playerTextureAtlas = [SKTextureAtlas atlasNamed:@"player"];
    }
    return _playerTextureAtlas;
}

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
    
    SKTexture* hullTexture = [SKTexture textureWithImageNamed:@"rocket.png"];
    
    //for(int i=0;i<10;i++)
    {
        self.spaceship = [self newSpaceshipWithTexture:hullTexture];
        self.spaceship.position = [self getRandomSpaceshipLocation];
        
        [self addChild:self.spaceship];
    }
    SKAction* makeRocks = [SKAction sequence:@[
                                               [SKAction performSelector:@selector(addRock) onTarget:self],
                                               [SKAction waitForDuration:0.10 withRange:0.15]
                                               ]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
}

-(NSArray*) getPlayerWalkTextures
{
    NSMutableArray* playerWalkTextures = [[NSMutableArray alloc] initWithCapacity:35];
    NSString* pl;
    for(int i=1;i<=9;i++)
    {
        //playerWalkTextures addObject:[atlas textureNamed:[NSString stringWithFormat:@"player_"]]
        if(i<10)
            pl = [NSString stringWithFormat:@"player_000%i.png",i];
        else
            pl = [NSString stringWithFormat:@"player_00%i.png",i];
        
        [playerWalkTextures addObject:[SKTexture textureWithImageNamed:pl]];
    }
    return playerWalkTextures;
}

-(CGPoint) getRandomSpaceshipLocation
{
    //return CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return CGPointMake(skRand(0,self.frame.size.width), skRand(0,self.frame.size.height));
}

-(SKSpriteNode*) newSpaceshipWithTexture: (SKTexture*) hullTexture
{
    SKSpriteNode* hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 64)];

    SKAction* hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:3.0],
                                           [SKAction moveByX:320.0 y:200.0 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-320.0 y:-200.0 duration:1.0]
                                           ]];
    /*SKAction* pulseRed = [SKAction sequence:@[
                                              [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.5 duration:0.15],
                                              [SKAction waitForDuration:0.5],
                                              [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]
                                              ]];*/
    
    NSArray* playerWalkTextures = [self getPlayerWalkTextures];
    SKAction* playerWalkAnimation = [SKAction animateWithTextures:playerWalkTextures timePerFrame:0.1];

    //SKSpriteNode* hull = [SKSpriteNode spriteNodeWithTexture:hullTexture];
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    [hull runAction:[SKAction repeatActionForever:hover]];
    [hull runAction:[SKAction repeatActionForever:playerWalkAnimation]];
    //[hull runAction:[SKAction repeatActionForever:pulseRed]];
    
    SKSpriteNode* light1 = [self newLight];
    SKSpriteNode* light2 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    light2.position = CGPointMake(28.0, 6.0);
    //[hull addChild:light1];
    //[hull addChild:light2];
    
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

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high-low) + low;
}

-(void) addRock
{
    SKTexture* rockTexture = [SKTexture textureWithImageNamed:@"tile.png"];
    SKSpriteNode* rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(26, 26)];

    rock.texture = rockTexture;
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void) didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode* node, BOOL *stop)
     {
         if(node.position.y < 0)
         {
             [node removeFromParent];
         }
     }];
}


@end
