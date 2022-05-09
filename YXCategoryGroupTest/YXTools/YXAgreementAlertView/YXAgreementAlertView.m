//
//  YXAgreementAlertView.m
//  MuchProj
//
//  Created by Augus on 2021/11/23.
//

#import "YXAgreementAlertView.h"

@interface YXAgreementAlertView () <YYTextViewDelegate>

@property (nonatomic, strong) UIView *bgView; //背景视图
@property (nonatomic, strong) UILabel *titleLab; //标题
@property (nonatomic, strong) YYTextView *describeTextView; //详情显示
@property (nonatomic, strong) UIView *btnBgView; //按钮背景视图
@property (nonatomic, strong) UIButton *cancelBtn; //不同意按钮
@property (nonatomic, strong) UIButton *sureBtn; //同意按钮

@end

@implementation YXAgreementAlertView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    self.titleLab.text = @"服务条款和隐私保护提示";
    [self.cancelBtn setTitle:@"不同意并退出App" forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"同意" forState:UIControlStateNormal];
    [self setDescribeTextViewAttributed];
}

#pragma mark - progress
#pragma mark - 跳转到会员协议
- (void)pushToAgreementVC {
    
    [self alertViewDismiss];
    if (self.yxAgreementAlertVBlock) {
        self.yxAgreementAlertVBlock(YXAgreementAlertVTypeAgreement);
    }
}
#pragma mark - 跳转到隐私政策
- (void)pushToPrivacyVC {
    
    [self alertViewDismiss];
    if (self.yxAgreementAlertVBlock) {
        self.yxAgreementAlertVBlock(YXAgreementAlertVTypePolicyVC);
    }
}

#pragma mark - 同意
- (void)progressSureBtn {
    
    [self alertViewDismiss];
    if (self.yxAgreementAlertVBlock) {
        self.yxAgreementAlertVBlock(YXAgreementAlertVTypeSure);
    }
}

#pragma mark - 不同意
- (void)progressCancelBtn {
    
    [self alertViewDismiss];
    if (self.yxAgreementAlertVBlock) {
        self.yxAgreementAlertVBlock(YXAgreementAlertVTypeNotSure);
    }
}

#pragma mark - 视图消失
- (void)alertViewDismiss {
    
    [self.alertController dismissViewControllerAnimated:YES];
}

#pragma mark - 设置内容显示
- (void)setDescribeTextViewAttributed {
    
    kYXWeakSelf
    NSString *agreementStr = @"《用户服务协议》";
    NSString *policyStr = @"《隐私政策》";
    NSString *discribeStr = [NSString stringWithFormat:@"欢迎使用潮狗！\n\n在使用我们的产品和服务前，请您先阅读并了解%@、%@。\n我们我们将严格按照上述协议为您提供服务，保护您的信息安全，点击“同意”即表示您已阅读并同意全部条款，可以继续使用我们的产品和服务。", agreementStr, policyStr];
    
    NSRange agreementRange = [discribeStr rangeOfString:agreementStr];
    NSRange policyRange = [discribeStr rangeOfString:policyStr];
    
    UIColor *highColor = kYXDiyColor(@"#093B91", 1);
    UIColor *textColor = kYXDiyColor(@"#888888", 1);
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:discribeStr];
    attString.yy_color = textColor;
    [attString yy_setTextHighlightRange:agreementRange color:highColor backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {

        [weakSelf pushToAgreementVC];
    }];
    [attString yy_setTextHighlightRange:policyRange color:highColor backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
        [weakSelf pushToPrivacyVC];
    }];
    
    attString.yy_font = self.describeTextView.font;
    attString.yy_lineSpacing = 10; //行间距
    attString.yy_minimumLineHeight = 16; //最小行高
    attString.yy_maximumLineHeight = attString.yy_font.lineHeight; //最大行高
    
    self.describeTextView.attributedText = attString;
}

#pragma mark - setting
- (void)setBaseVC:(YXBaseVC *)baseVC {
    
    _baseVC = baseVC;
}

#pragma mark - 懒加载
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 15;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
            make.height.mas_equalTo(402 *(kYXWidth /375));
            make.centerY.equalTo(self);
        }];
    };
    return _bgView;
}
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = kYXFontBold(16);
        _titleLab.textColor = kYXMainTitleColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.bgView).with.offset(25);
            make.left.equalTo(self.bgView).with.offset(20);
            make.right.equalTo(self.bgView).with.offset(-20);
        }];
    }
    return _titleLab;
}
- (YYTextView *)describeTextView {
    
    if (!_describeTextView) {
        _describeTextView = [YYTextView new];
        _describeTextView.font = kYXFontSystem(14);
        _describeTextView.textAlignment = NSTextAlignmentLeft;
        _describeTextView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _describeTextView.textColor = kYXDiyColor(@"#888888", 1);
        _describeTextView.editable = NO;
        _describeTextView.delegate = self;
        [self.bgView addSubview:_describeTextView];
        [_describeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(self.titleLab);
            make.top.equalTo(self.titleLab.mas_bottom).with.offset(30);
            make.bottom.equalTo(self.btnBgView.mas_top).with.offset(-25);
        }];
    }
    return _describeTextView;
}
- (UIView *)btnBgView {
    
    if (!_btnBgView) {
        _btnBgView = [UIView new];
        [self.bgView addSubview:_btnBgView];
        [_btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.bottom.equalTo(self.bgView);
            make.height.mas_equalTo(94);
        }];
    }
    return _btnBgView;
}
- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sureBtn setTitleColor:kYXWhiteColor forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:kYXFontSystem(14)];
        [_sureBtn setBackgroundColor:kYXThemeColor];
        [_sureBtn addTarget:self action:@selector(progressSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBgView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.btnBgView);
            make.right.equalTo(self.btnBgView).with.offset(-68);
            make.left.equalTo(self.btnBgView).with.offset(68);
            make.height.mas_equalTo(40);
        }];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitleColor:kYXMainDescribeColor forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:kYXFontSystem(12)];
        [_cancelBtn addTarget:self action:@selector(progressCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBgView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.height.equalTo(self.sureBtn);
            make.top.equalTo(self.sureBtn.mas_bottom).with.offset(4);
        }];
    }
    return _cancelBtn;
}

@end
