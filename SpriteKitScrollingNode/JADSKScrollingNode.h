//
//  JADSKScrollingNode.h
//  FirstLetters
//
//  Created by Jennifer Dobson on 7/25/14.
//  Copyright (c) 2014 Jennifer Dobson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//@interface JADSKScrollingNode : SKCropNode <UIGestureRecognizerDelegate>
@interface JADSKScrollingNode : SKNode <UIGestureRecognizerDelegate>

@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint snapInPoint;
@property (nonatomic) BOOL snapIn;

-(id)initWithSize:(CGSize)size;
-(void)scrollToTop;
-(void)scrollToBottom;
-(void)enableHorizontalScrollingOnView:(UIView*)view;
-(void)enableVerticalScrollingOnView:(UIView*)view;
-(void)disableScrollingOnView:(UIView*)view;
-(void)enableSnapInAtPoint:(CGPoint)point;
-(void)disableSnapIn;

@end
