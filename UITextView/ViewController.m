//
//  ViewController.m
//  UITextView
//
//  Created by hx_leichunxiang on 14-10-30.
//  Copyright (c) 2014年 lcx. All rights reserved.
//  功能描述：1、textview限制输入最大长度；2、汉字算一个字或者两个字

#import "ViewController.h"

#define kMax_InputLength 10
#define kNumofChineseCharacter 2 //汉字计几个字节

@interface ViewController ()<UITextViewDelegate>
{
    UITextView *_textView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
    _textView.backgroundColor = [UIColor orangeColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];;
    NSLog(@"length == %lu",(unsigned long)[self unicodeLengthOfString:@"阿里成为美国史上最大规模IPO，也引发了人们对于互联网行业好公司的思考,什么样的互联网公司才是好公司?以下就是小编从不同角度整理的那些好互联网公司的共性及独特之处。"]);
    NSLog(@"，== %lu",(unsigned long)[self unicodeLengthOfString:@"，"]);//搜狗拼音中文标点，计长度为2.
    NSLog(@",== %lu",(unsigned long)[self unicodeLengthOfString:@","]);//英文输入标点，计长度为1.
    NSLog(@"?== %lu",(unsigned long)[self unicodeLengthOfString:@"?"]);
    NSLog(@"。== %lu",(unsigned long)[self unicodeLengthOfString:@"。"]);

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
}

//用于限制UITextView的输入中英文限制
-(void)limitIncludeChineseTextView:(UITextView *)textview Length:(NSUInteger)kMaxLength
{
    NSString *toBeString = textview.text;
    NSUInteger length = [self unicodeLengthOfString:toBeString];
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textview markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textview positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (length > kMaxLength) {
                
                textview.text = [self subStringIncludeChinese:toBeString ToLength:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (length > kMaxLength) {
            textview.text = [self subStringIncludeChinese:toBeString ToLength:kMaxLength];
        }
    }
}


//字符串截到对应的长度包括中文 一个汉字算2个字符
- (NSString *)subStringIncludeChinese:(NSString *)text ToLength:(NSUInteger)length{
  
  //    NSUInteger allLength=[self unicodeLengthOfString:text];
  //    if (text==nil  || length>allLength) {
  //        return text;
  //    }
  
  
  NSUInteger asciiLength = 0;
  NSUInteger location = 0;
  for(NSUInteger i = 0; i < text.length; i++) {
      unichar uc = [text characterAtIndex: i];
      asciiLength += isascii(uc) ? 1 : kNumofChineseCharacter;
      
      if (asciiLength==length) {
          location=i;
          break;
      }else if (asciiLength>length){
          location=i-1;
          break;
      }
      
  }
  
  NSString *finalStr=[text substringToIndex:location+1];
  
  return finalStr;
}


//判断输入的字符长度 一个汉字算2个字符
- (NSUInteger)unicodeLengthOfString:(NSString *)text {
    NSUInteger asciiLength = 0;
    for(NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : kNumofChineseCharacter;
    }
    return asciiLength;
}

- (void)textViewDidChange:(NSNotification *)obj
{
    [self limitIncludeChineseTextView:_textView Length:kMax_InputLength];
    NSLog(@"length == %lu",(unsigned long)[self unicodeLengthOfString:_textView.text]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
