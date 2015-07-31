//
//  JADMainScene.m
//  SpriteKitScrollingNode
//
//  Created by Jennifer Dobson on 7/25/14.
//  Copyright (c) 2014 Jennifer Dobson. All rights reserved.
//

#import "JADMainScene.h"
#import "JADSKScrollingNode.h"
#import "JADViewController.h"


@interface JADMainScene()

@property (nonatomic, strong) JADSKScrollingNode* scrollingNode;

@end

@implementation JADMainScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _scrollingNode = [[JADSKScrollingNode alloc] initWithSize:size];
        _scrollingNode.position = CGPointMake(0, 0);
        
        [self addChild:_scrollingNode];
        
        SKLabelNode *topLabelNode = [[SKLabelNode alloc] init];
        topLabelNode.text = @"Top";
        topLabelNode.position = CGPointMake(50, 2000-50);
        topLabelNode.name=@"top";
        
        SKLabelNode *bottomLabelNode = [[SKLabelNode alloc] init];
        bottomLabelNode.text = @"Bottom";
        bottomLabelNode.position = CGPointMake(50, 50);
        bottomLabelNode.name=@"btm";
        SKSpriteNode *node1 = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(800, 450)];
        SKSpriteNode *node2 = [node1 copy];
        SKSpriteNode *node3 = [node1 copy];
        
        
        node1.position = CGPointMake(_scrollingNode.size.width/2, _scrollingNode.size.height/2);
        node2.position = CGPointMake(512, 1000);
        node3.position = CGPointMake(512, 1500);
        node1.name = @"node1";
        node2.name = @"node2";
        node3.name = @"node3";
        [_scrollingNode addChild:topLabelNode];
        [_scrollingNode addChild:bottomLabelNode];
        [_scrollingNode addChild:node1];
        [_scrollingNode addChild:node2];
        [_scrollingNode addChild:node3];
        
        
        
        SKLabelNode* otherSceneNode = [SKLabelNode node];
        otherSceneNode.text = @"Switch To Part Scrolling Scene";
        otherSceneNode.name = @"OtherSceneNode";
        otherSceneNode.position = (CGPoint){800,100};
        [self addChild:otherSceneNode];
        
        SKSpriteNode *snapinNode = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)];
        snapinNode.position = CGPointMake(_scrollingNode.size.width/2, _scrollingNode.size.height/2);
        [self addChild:snapinNode];

    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    
    [_scrollingNode enableVerticalScrollingOnView:view];
    [_scrollingNode enableSnapInAtPoint:CGPointMake(_scrollingNode.size.width/2, _scrollingNode.size.height/2)];
    [_scrollingNode scrollToTop];
    
}

-(void)willMoveFromView:(SKView *)view
{
    [_scrollingNode disableScrollingOnView:view];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    NSString* nodeName = touchedNode.name;
    if ([touchedNode isKindOfClass:[SKSpriteNode class]]) {
        SKAction *blueAction = [SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1 duration:.5];
        SKAction *redAction = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:.5];
        [touchedNode runAction:[SKAction sequence:@[blueAction,redAction]]];
    }
    else if ([nodeName isEqualToString:@"OtherSceneNode"])
        [self.viewController presentPartScrollingScene];
        
}
@end
