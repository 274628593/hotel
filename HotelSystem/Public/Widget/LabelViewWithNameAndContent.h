//
//  LabelWithNameAndContent.h
//  MachineModule
//
//  Created by LHJ on 15/12/15.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int{
    RightContentType_Text = 1, /* 文字类型 */
    RightContentType_Star, /* 评论星星类型，用m_titalNumOfStar 和 m_numOfStar控制 */
} RightContentType;

/** 显示左侧标题和右侧内容的View  */
@interface LabelViewWithNameAndContent : UIView

// ==============================================================================================
#pragma mark -  外部方法

// ==============================================================================================
#pragma mark -  外部变量
/** 左侧名字要设置几个字的宽度，以m_textFont为字体大小测算宽度，默认四个字宽度 */
@property(nonatomic, assign , setter=setNumOfNameWidth:, getter=getNumOfNameWidth) int m_numOfNameWidth;

/** 总共的星星个数 */
@property(nonatomic, assign , setter=setTitalNumOfStar:, getter=getTitalNumOfStar) int m_titalNumOfStar;

/** 目前的星星评论个数 */
@property(nonatomic, assign, setter=setNumOfStar:, getter=getNumOfStar) int m_numOfStar;

/** 字体 */
@property(nonatomic, retain , setter=setTextFont:, getter=getTextFont) UIFont *m_textFont;

/** 左侧字体颜色 */
@property(nonatomic, retain, setter=setNameColor:, getter=getNameColor) UIColor *m_nameColor;

/** 右侧字体颜色 */
@property(nonatomic, retain, setter=setContentColor:, getter=getContentColor) UIColor *m_contentColor;

/** 左侧文字 */
@property(nonatomic, copy , setter=setName:, getter=getName) NSString *m_strName;

/** 右侧文字 */
@property(nonatomic, copy , setter=setContent:, getter=getContent) NSString *m_strContent;

/** 左侧图片，如果为nil，则不显示 */
@property(nonatomic, retain, setter=setImg:, getter=getImg) UIImage *m_img;

/** 是否显示小一号的图片（为原先的一半），默认NO */
@property(nonatomic, assign, setter=setIsShowSmallImg:, getter=getIsShowSmallImg) BOOL m_bIsShowSmallImg;

/** 是否显示右侧箭头，默认NO */
@property(nonatomic, assign, setter=setIsShowRightArrow:, getter=getIsShowRightArrow) BOOL m_bIsShowRightArrow;

/** 是否显示底部线条，默认NO */
@property(nonatomic, assign, setter=setIsShowLine:, getter=getIsShowLine) BOOL m_bIsShowLine;

/** 左边文字和右边文字之间的间距 */
@property(nonatomic, assign, setter=setSpaceXInsert:, getter=getSpaceXInsert) float m_spaceXInsert;

/** 左边Lab的TextAlignment */
@property(nonatomic, assign, setter=setTextAlignmentOfLeftLab:) NSTextAlignment m_textAlignmentOfLeftLab;

/** View类型，目前有两种，右边是文字或者图片评论星星类型，默认值RightContentType_Text */
@property(nonatomic, assign, setter=setRightContentType:) RightContentType m_rightContentType;

@end
