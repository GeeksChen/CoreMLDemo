//
//  ViewController.m
//  CoreMLDemo
//
//  Created by Developer_Yi on 2017/6/10.
//  Copyright © 2017年 medcare. All rights reserved.
//

#import "ViewController.h"
#import <CoreML/CoreML.h>
#import "UIImage+Utils.h"
#import <Vision/Vision.h>
#import "GoogLeNetPlaces.h"
#import "Inceptionv3.h"
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *predictImageView;
@property (weak, nonatomic) IBOutlet UIButton *ANNTypeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *ANNTypeBtn2;
@property (weak, nonatomic) IBOutlet UILabel *predictResultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *reg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    self.predictImageView.userInteractionEnabled=YES;
    [self.predictImageView addGestureRecognizer:reg];
}
#pragma mark-GoogleNetPlaces
- (IBAction)ANNTypeBtn1_Click:(id)sender {
    if([self.predictImageView.image isKindOfClass:[NSNull class]]||self.predictImageView.image==nil)
    {
        UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"" message:@"预测图片不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else
    {
        
        CGImageRef imageRef=self.predictImageView.image.CGImage;
        NSError *err=nil;
        GoogLeNetPlaces *modelV3=[[GoogLeNetPlaces alloc]init];
        
       VNCoreMLModel *MODEL=[VNCoreMLModel modelForMLModel:modelV3.model error:&err];
        VNCoreMLRequest *request=[[VNCoreMLRequest alloc]initWithModel:MODEL completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            CGFloat confidence = 0.0f;
            VNClassificationObservation *tempClassification = nil;
            for (VNClassificationObservation *classification in request.results) {
                if (classification.confidence > confidence)
                {
                    confidence = classification.confidence;
                    tempClassification = classification;
                    
                }
                
            }
            self.predictResultLabel.text = [NSString stringWithFormat:@"识别结果:%@-----匹配率为;%@",tempClassification.identifier,@(tempClassification.confidence)];
        }];
        VNImageRequestHandler *handler=[[VNImageRequestHandler alloc]initWithCGImage:imageRef options:nil];
        NSError *error = nil;
        [handler performRequests:@[request] error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
}
#pragma mark-Inceptionv3
- (IBAction)ANNTypeBtn2_click:(id)sender {
    if([self.predictImageView.image isKindOfClass:[NSNull class]]||self.predictImageView.image==nil)
    {
        UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"" message:@"预测图片不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else
    {
        CGImageRef imageRef=self.predictImageView.image.CGImage;
        NSError *err=nil;
        Inceptionv3 *modelV3=[[Inceptionv3 alloc]init];
        
        VNCoreMLModel *MODEL=[VNCoreMLModel modelForMLModel:modelV3.model error:&err];
        VNCoreMLRequest *request=[[VNCoreMLRequest alloc]initWithModel:MODEL completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            CGFloat confidence = 0.0f;
            VNClassificationObservation *tempClassification = nil;
            for (VNClassificationObservation *classification in request.results) {
                if (classification.confidence > confidence)
                {
                    confidence = classification.confidence;
                    tempClassification = classification;
                    
                }
                
            }
            self.predictResultLabel.text = [NSString stringWithFormat:@"识别结果:%@-----匹配率为;%@",tempClassification.identifier,@(tempClassification.confidence)];
        }];
        VNImageRequestHandler *handler=[[VNImageRequestHandler alloc]initWithCGImage:imageRef options:nil];
        NSError *error = nil;
        [handler performRequests:@[request] error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
}
#pragma mark - 图片点击
- (void)tap
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = [UIColor blackColor];
    //通过拍照上传图片
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    //从手机相册中选择上传图片
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    self.predictImageView.image = newPhoto;
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
