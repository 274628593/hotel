//
//  GetPhoto.m
//  MachineModule
//
//  Created by LHJ on 15/12/30.
//  Copyright © 2015年 LHJ. All rights reserved.
//

#import "GetPhoto.h"
#import "CPublic.h"

static GetPhoto *GetPhotoObj;

typedef enum : int{
    ViewTag_Photo = 1, /* 对话框的Tag */
    
}ViewTag;

@implementation GetPhoto

@synthesize m_delegate;

// ============================================================================================
#pragma mark 外部调用方法
+ (void) openViewWithSelectPhoto:(id)v_delegate
{
    if(GetPhotoObj == nil){
        GetPhotoObj = [GetPhoto new];
    }
    [GetPhotoObj setDelegate:v_delegate];
    [GetPhotoObj startPhoto];
}

// ============================================================================================
#pragma mark 内部调用方法
/** 打开选择照片的界面 */
- (void) startPhoto
{
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择添加照片的方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册", @"拍照", nil];
        dialog.tag = ViewTag_Photo;
        [dialog show];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择添加照片的方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相册", nil];
        dialog.tag = ViewTag_Photo;
        [dialog show];
    }
}

// ==============================================================================================
#pragma mark 委托协议UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
}
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int tag = (int)alertView.tag;
    if(tag == ViewTag_Photo){
        NSUInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:{ // 取消
                return;
            }
            case 1:{ // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2:{ // 拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            default:
                break;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = (id)self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [[CPublic appRootViewController] presentViewController:imagePickerController animated:YES completion:nil];
    }
}
// ============================================================================
#pragma mark 委托协议UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    //    UIImage *imageResult = [UIImage imageWithData: imageData];
    if(m_delegate != nil){
        BOOL bTemp = [m_delegate respondsToSelector:@selector(getImgData:_sender:)];
        if(bTemp == YES){
            [m_delegate getImgData:imageData _sender:self];
        }
    }
}
// 点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
