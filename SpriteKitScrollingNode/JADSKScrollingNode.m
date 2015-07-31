//
//  JADSKScrollingNode.m
//  FirstLetters
//
//  Created by Jennifer Dobson on 7/25/14.
//  Copyright (c) 2014 Jennifer Dobson. All rights reserved.
//

#import "JADSKScrollingNode.h"


@interface JADSKScrollingNode()

@property (nonatomic) CGFloat minYPosition;
@property (nonatomic) CGFloat maxYPosition;
@property (nonatomic) CGFloat minXPosition;
@property (nonatomic) CGFloat maxXPosition;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGFloat yOffset;
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat biggestNodeWidth;
@property (nonatomic) CGFloat biggestNodeHeight;
@property (nonatomic) CGFloat lastTranslationX;
@property (nonatomic) CGFloat lastTranslationY;
@property (nonatomic) Boolean vertical;
@end


static const CGFloat kScrollDuration = .3;

@implementation JADSKScrollingNode

-(id)initWithSize:(CGSize)size
{
    self = [super init];
    
    if (self)
    {
        _size = size;
        //CGRect frame = [self calculateAccumulatedFrame];
        _yOffset = [self calculateAccumulatedFrame].origin.y;
        _xOffset = [self calculateAccumulatedFrame].origin.x;
        _snapIn = NO;
    }
    return self;
    
}
-(void)snapInAt:(CGPoint)snapinPoint {
    _snapInPoint = snapinPoint;
}

-(void)addChild:(SKNode *)node
{
    [super addChild:node];
    //_yOffset = [self calculateAccumulatedFrame].origin.y;
    
    //NSLog(@"_xOffset:%f",_xOffset);
    _xOffset = _xOffset - _biggestNodeWidth/2;
    _yOffset = _yOffset - _biggestNodeHeight/2;
    
    if(_xOffset != INFINITY){
        _xOffset = MAX(_xOffset, [self calculateAccumulatedFrame].origin.x);
    }
    else {
        _xOffset = [self calculateAccumulatedFrame].origin.x;
    }
    if(NO){
        _yOffset = MAX(_yOffset, [self calculateAccumulatedFrame].origin.y);
    }
    else {
        _yOffset = [self calculateAccumulatedFrame].origin.y;
    }
    
    
    if (_biggestNodeHeight < node.frame.size.height)
    {
        _biggestNodeHeight = node.frame.size.height;
    }
    
    if (_biggestNodeWidth < node.frame.size.width)
    {
        _biggestNodeWidth = node.frame.size.width;
    }
    
    _xOffset = _xOffset;// + _biggestNodeWidth/2;
    _yOffset = _yOffset;// + _biggestNodeHeight/2;
    NSLog(@"_xOffset:%f",_xOffset);
}


-(CGFloat) minYPosition
{
    CGSize parentSize = self.parent.frame.size;
    //-nearestToY0.position.y +_snapInPoint.y
    
    CGFloat minPosition =(parentSize.height - [self calculateAccumulatedFrame].size.height - _yOffset -_snapInPoint.y);
    
    return minPosition;
    
    
}

-(CGFloat) minXPosition
{
    CGSize parentSize = self.parent.frame.size;
    
    
    CGFloat minPosition =(parentSize.width - [self calculateAccumulatedFrame].size.width - _xOffset -_snapInPoint.x);
    NSLog(@"minXPosition:%f",minPosition);
    return minPosition;
    
    
}

-(CGFloat) maxXPosition
{
    return 0;
}

-(CGFloat) maxYPosition
{
    return 0+_snapInPoint.y;
}

-(void)scrollToBottom
{
    self.position = CGPointMake(0, self.maxYPosition);
    [self moveToDoneAnimated:NO];
}

-(void)scrollToTop
{
    self.position = CGPointMake(0, self.minYPosition);
    [self moveToDoneAnimated:NO];
    
}

-(void)enableScrollingOnView:(UIView*)view
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        _gestureRecognizer.delegate = self;
        [view addGestureRecognizer:self.gestureRecognizer];
    }
}

-(void)enableHorizontalScrollingOnView:(UIView*)view
{
    [self enableScrollingOnView:view];
    _vertical = NO;
    
}

-(void)enableVerticalScrollingOnView:(UIView*)view
{
    [self enableScrollingOnView:view];
    _vertical = YES;
    
}

-(void)disableScrollingOnView:(UIView*)view
{
    if (_gestureRecognizer) {
        [view removeGestureRecognizer:_gestureRecognizer];
        _gestureRecognizer = nil;
    }
}

-(void)enableSnapInAtPoint:(CGPoint)point {
    _snapIn = YES;
    _snapInPoint = point;
}

-(void)disableSnapIn {
    _snapIn = NO;
}

-(void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
    
    
    
    if(_vertical)
    {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            translation = CGPointMake(translation.x, -translation.y);
            [self panForTranslation:translation];
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
            
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = self.position;
            CGPoint p = mult(velocity, kScrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x, pos.y - p.y);
            newPos = [self constrainStencilNodesContainerPosition:newPos];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:kScrollDuration];
            //SKAction *moveMask = [SKAction moveTo:[self maskPositionForNodePosition:newPos] duration:kScrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            //[moveMask setTimingMode:SKActionTimingEaseOut];
            [self runAction:moveTo completion:^{
                [self moveToDoneAnimated:YES];
                
            }];
            //[self.maskNode runAction:moveMask];
            
        }
    }
    else {
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            translation = CGPointMake(translation.x, -translation.y);
            //NSLog(@"TranslationX:%f",translation.x);
            //NSLog(@"TranslationY:%f",translation.y);
            _lastTranslationX = translation.x;
            [self panForTranslation:translation];
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
            
        } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            translation = CGPointMake(translation.x, -translation.y);
            NSLog(@"TranslationX:%f",translation.x);
            NSLog(@"TranslationY:%f",translation.y);
            
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            NSLog(@"VelocityX:%f",velocity.x);
            NSLog(@"VelocityY:%f",velocity.y);
            CGPoint pos = self.position;
            CGPoint p = mult(velocity, kScrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y);
            newPos = [self constrainStencilNodesContainerPosition:newPos];
            
            if(_lastTranslationX<0.5){
                [self moveToDoneAnimated:YES];
            }
            else {
                SKAction *moveTo = [SKAction moveTo:newPos duration:kScrollDuration];
                //SKAction *moveMask = [SKAction moveTo:[self maskPositionForNodePosition:newPos] duration:kScrollDuration];
                [moveTo setTimingMode:SKActionTimingEaseOut];
                //[moveMask setTimingMode:SKActionTimingEaseOut];
                [self runAction:moveTo completion:^{
                    [self moveToDoneAnimated:YES];
                }];
            }
            //[self.maskNode runAction:moveMask];
        }
    }
    
}

-(void)moveToDoneAnimated:(BOOL)animated {
    NSLog(@"completed move");
    
    float duration = .0;
    if(animated)
    {
        duration = 0.2;
    }
    if(!_vertical && _snapIn){
        SKNode *nearestToX0 = nil;
        for (SKNode *eachNode in self.children){
            CGPoint position = eachNode.position;
            if(nearestToX0) {
                float xNearest = nearestToX0.position.x+self.position.x - _snapInPoint.x;
                float xEach = eachNode.position.x + self.position.x -_snapInPoint.x;
                
                if (xEach<0) {
                    xEach = xEach * (-1);
                }
                if (xNearest<0) {
                    xNearest = xNearest * (-1);
                }
                
                
                
                if(xEach<xNearest){
                    nearestToX0 = eachNode;
                }
                
                
            }
            else {
                nearestToX0 = eachNode;
            }
            
            
            //[eachNode convertPoint:position toNode:self.parent.parent];
            NSLog(@"position of child after conversion %f, %f", position.x+self.position.x, position.y+self.position.y);
        }
        CGPoint newPosition = CGPointMake(0-nearestToX0.position.x, 0-nearestToX0.position.y);
        
        
        SKAction *moveTo = [SKAction moveTo:newPosition duration:duration];
        //SKAction *moveMask = [SKAction moveTo:[self maskPositionForNodePosition:newPos] duration:kScrollDuration];
        [moveTo setTimingMode:SKActionTimingEaseOut];
        //[moveMask setTimingMode:SKActionTimingEaseOut];
        [self runAction:moveTo];
    }
    else
    {
        SKNode *nearestToY0 = nil;
        for (SKNode *eachNode in self.children){
            CGPoint position = eachNode.position;
            NSLog(@"position y:%f", self.position.y);
            NSLog(@"_snapInPoint y:%f", _snapInPoint.y);
            NSLog(@"nearestToY0 y:%f", nearestToY0.position.y);
            NSLog(@"eachNode y:%f", eachNode.position.y);
            NSLog(@"nodeName:%@", eachNode.name);
            if(nearestToY0) {
                
                
                
                float xNearest = nearestToY0.position.y+self.position.y - _snapInPoint.y;
                float xEach = eachNode.position.y + self.position.y -_snapInPoint.y;
                
                if (xEach<0) {
                    xEach = xEach * (-1);
                }
                if (xNearest<0) {
                    xNearest = xNearest * (-1);
                }
                
                
                
                if(xEach<xNearest){
                    nearestToY0 = eachNode;
                }
                
                
            }
            else {
                nearestToY0 = eachNode;
            }
            
            
            //[eachNode convertPoint:position toNode:self.parent.parent];
            NSLog(@"position of child after conversion %f, %f", self.position.y, position.y+self.position.y);
        }
        CGPoint newPosition = CGPointMake(self.position.x, 0-nearestToY0.position.y +_snapInPoint.y);
        
        SKAction *moveTo = [SKAction moveTo:newPosition duration:duration];
        //SKAction *moveMask = [SKAction moveTo:[self maskPositionForNodePosition:newPos] duration:kScrollDuration];
        [moveTo setTimingMode:SKActionTimingEaseOut];
        //[moveMask setTimingMode:SKActionTimingEaseOut];
        [self runAction:moveTo];
    }
    
    
}

-(void)panForTranslation:(CGPoint)translation
{
    if(_vertical){
        self.position = CGPointMake(self.position.x, self.position.y+translation.y);
    } else {
        self.position = CGPointMake(self.position.x+translation.x, self.position.y);
        
    }
}

- (CGPoint)constrainStencilNodesContainerPosition:(CGPoint)position {
    
    CGPoint retval = position;
    
    if (_vertical) {
        retval.x = self.position.x;
        retval.y = MAX(retval.y, self.minYPosition);
        retval.y = MIN(retval.y, self.maxYPosition);
    } else {
        NSLog(@"retvalX:%f",retval.x);
        retval.y = self.position.y;
        retval.x = MAX(retval.x, self.minXPosition);
        retval.x = MIN(retval.x, self.maxXPosition);
    }
    
    
    
    
    return retval;
}


CGPoint mult(const CGPoint v, const CGFloat s) {
    return CGPointMake(v.x*s, v.y*s);
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    SKNode* grandParent = self.parent.parent;
    
    if (!grandParent) {
        grandParent = self.parent;
    }
    CGPoint touchLocation = [touch locationInNode:grandParent];
    
    if (!CGRectContainsPoint(self.parent.frame,touchLocation)){
        return NO;
    }
    
    return YES;
}

@end
