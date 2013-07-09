//
//  SpriteViewController.m
//  SpriteWalkThrough
//
//  Created by Farhan Khan on 2013-07-09.
//  Copyright (c) 2013 Farhan Khan. All rights reserved.
//

#import "SpriteViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "HelloScene.h"

@interface SpriteViewController ()

@end

@implementation SpriteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    SKView* spriteView = (SKView*) self.view;
    spriteView.showsNodeCount = YES;
    spriteView.showsDrawCount = YES;
    spriteView.showsFPS = YES;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    HelloScene* hello = [[HelloScene alloc] initWithSize:CGSizeMake(768,1024)];
    SKView* spriteView = (SKView*) self.view;
    [spriteView presentScene:hello];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
