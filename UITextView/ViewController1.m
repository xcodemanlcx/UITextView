//
//  ViewController1.m
//  UITextView
//
//  Created by hx_leichunxiang on 14-10-30.
//  Copyright (c) 2014年 lcx. All rights reserved.
//  功能：带textview输入框的键盘
//  实现思路：设置带textview的自定义视图，为一个虚拟textfield的inputAccessoryView属性值。

#import "ViewController1.h"

@interface ViewController1 ()<UITextViewDelegate>
{
    UITextField *_virtualTextField;
    UITextView *_textView;
    BOOL isUp;
}
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTextViewWithSelfViewDemo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 功能1：- TextView键盘上自定义view：设置属性inputAccessoryView
- (void)createTextViewWithSelfViewDemo
{
    //虚拟输入框，用于弹出键盘
    _virtualTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGFLOAT_MAX, 10, 10)];
    [self.view addSubview:_virtualTextField];
    
    //控制键盘 隐藏或显示
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 40, 200, 60);
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 30;
    [btn setTitle:@"弹出或者关闭键盘" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //自定义view
    UIView *inputview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    inputview.backgroundColor = [UIColor redColor];
    
    //输入框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
    [inputview addSubview:_textView];
    _textView.backgroundColor = [UIColor blueColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textColor = [UIColor grayColor];
    
    //1-0 自定义键盘顶部视图
    _virtualTextField.inputAccessoryView =inputview;
    
}

- (void)btnAction
{
    isUp = !isUp;
    if (isUp)
    {
        [ _virtualTextField becomeFirstResponder];
        [_textView becomeFirstResponder];
    }
    else
    {
        [_textView resignFirstResponder];
        [_virtualTextField resignFirstResponder];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
