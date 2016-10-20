//
//  ViewControllerText.m
//  HotelSystem
//
//  Created by LHJ on 16/4/8.
//  Copyright © 2016年 hancj. All rights reserved.
//

#import "ViewControllerText.h"

@implementation ViewControllerText
{
    UIView      *m_viewLab;
    UILabel     *m_lab1;
    UILabel     *m_lab2;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    
    ViewTest *view = [ViewTest new];
    [view setFrame:CGRectMake(0, 0, 10, 10)];
    [self.view addSubview:view];
    m_viewLab = view;
     NSLog(@"lab%i", 1);
    UILabel *lab = [UILabel new];
    [lab setFrame:CGRectMake(0, 0, 4, 4)];
    m_lab1 = lab;
    [view addSubview:m_lab1];
    NSLog(@"lab%i", 1);
    
    lab = [UILabel new];
    [lab setFrame:CGRectMake(0, 0, 4, 4)];
    m_lab2 = lab;
    [m_lab1 addSubview:m_lab2];
    NSLog(@"lab%i", 2);
    
    [self performSelector:@selector(selectdddd) withObject:nil afterDelay:6];
}
- (void) selectdddd
{
    CGRect frame = m_lab1.frame;
    frame.size.height += 1;
    m_lab1.frame = frame;
//
//    CGRect frame = m_lab2.frame;
//    frame.size.height += 1;
//    m_lab2.frame = frame;
    
    frame = m_viewLab.frame;
    frame.size.height += 1;
    m_viewLab.frame = frame;
}
@end
