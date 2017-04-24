//
//  FRMessageView.m
//  FRMessage
//
//  Created by 曾凡旭 on 2017/4/24.
//  Copyright © 2017年 zengfxios. All rights reserved.
//

#import "FRMessageView.h"
#import "UIColor+FRAdd.h"
#import "NSString+FRAdd.h"
#import "Masonry.h"

static CGFloat const kPading_LeftRight = 20.0f;
static CGFloat const kPading_Msg_TopBottom = 10.0f;

static double  const kYPMessageAnimationDuration = 0.6f;
static CGFloat const kYPMessageTopToVCStartConstant = 20.0f;
static CGFloat const kYPMessageTopToVCFinalConstant = 84.0f;

@interface FRMessageView()

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,assign) BOOL useAnimation;

@property (nonatomic,strong) UIView *indicator;
@property (nonatomic,assign) CGSize indicatorSize;

@property (nonatomic, weak)  NSTimer *hideDelayTimer;

@end

@implementation FRMessageView
-(instancetype)init{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, kYPMessageTopToVCStartConstant, 0, 0);
        [self commInit];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self init];
}

+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message
{
    return [self showHUDAddedTo:view withMode:FRMessageHUDModeText withMessage:message];
}

+ (instancetype)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message withType:(FRMessageHUDType)type
{
    return [self showHUDAddedTo:view withType:type withMode:FRMessageHUDModeText withMessage:message];
}

+ (instancetype)showHUDAddedTo:(UIView *)view withMode:(FRMessageHUDMode)mode withMessage:(NSString *)message
{
    return [self showHUDAddedTo:view withType:FRMessageHUDTypeNormal withMode:mode withMessage:message];
}

+ (instancetype)showHUDAddedTo:(UIView *)view
                      withType:(FRMessageHUDType)type
                      withMode:(FRMessageHUDMode)mode
                   withMessage:(NSString *)message
{
    FRMessageView *hud = [[self alloc] initWithView:view];
    hud.labelText = message;
    hud.type = type;
    hud.mode = mode;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    FRMessageView *hud = [self HUDForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (FRMessageView*)HUDForView:(UIView *)view{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (FRMessageView *)subview;
        }
    }
    return nil;
}

-(void)commInit{
    [self setupDefaults];
    [self setupViews];
    [self updateIndicators];
}

-(void)setupViews{
    _label = [[UILabel alloc] init];
    _label.font = [UIFont boldSystemFontOfSize:14];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
}

-(void)setupDefaults{
    self.backgroundColor = [FRMessageConfig shared].normalColor;
    self.layer.cornerRadius = 25;
    self.alpha = 0.0;
    self.indicatorSize = CGSizeMake(15.0, 15.0);
    
    //
    self.type = FRMessageHUDTypeNormal;
    self.mode = FRMessageHUDModeText;
    self.position = FRMessagePositionTop;
}

#pragma mark - getter && setter
-(void)setType:(FRMessageHUDType)type{
    _type = type;
    switch (type) {
        case FRMessageHUDTypeNormal:{
            self.backgroundColor = [FRMessageConfig shared].normalColor;
        }
            break;
        case FRMessageHUDTypeWarning:{
            self.backgroundColor = [FRMessageConfig shared].warningColor;
        }
            break;
        case FRMessageHUDTypeError:{
            self.backgroundColor = [FRMessageConfig shared].errorColor;
        }
            break;
        case FRMessageHUDTypeSuccess:{
            self.backgroundColor = [FRMessageConfig shared].successColor;
        }
            break;
        default:{
            self.backgroundColor = [FRMessageConfig shared].normalColor;
        }
            break;
    }
    [self updateIndicators];
    [self setNeedsUpdateConstraints];
}

-(void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    _label.text = labelText;
    [self setNeedsUpdateConstraints];
}

-(void)setMode:(FRMessageHUDMode)mode{
    if(mode != _mode){
        _mode = mode;
        [self updateIndicators];
    }
}

#pragma mark - updateConstraints
-(void)updateConstraints{
    CGFloat mainW = [[UIScreen mainScreen] bounds].size.width;
    // 计算内容显示宽度
    CGFloat msgW = [_label.text widthForFont:_label.font]+1.0;
    CGFloat msgH = [_label.text heightForFont:_label.font width:msgW];
    CGFloat contentMaxW = mainW - 2*30.0;
    CGFloat contentW = 0.0;
    CGFloat textDisplayW = contentMaxW-2*kPading_LeftRight;
    if(self.indicator){
        contentW += self.indicatorSize.width + kPading_LeftRight*2 + 10 + msgW;
        textDisplayW = textDisplayW - self.indicatorSize.width - 10.0f;
    }
    else{
        contentW += msgW + 2*kPading_LeftRight;
    }
    
    if(msgW >= textDisplayW){
        msgH = [_label.text heightForFont:_label.font width:textDisplayW];
        contentW = contentMaxW;
    }
    CGFloat contentH = msgH + 2*kPading_Msg_TopBottom;
    
    self.layer.cornerRadius = contentH/2.0;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(contentW));
        make.height.equalTo(@(contentH));
        make.centerX.equalTo(self.superview);
    }];
    
    if(self.indicator){
        [self.indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kPading_LeftRight));
            make.size.mas_equalTo(self.indicatorSize);
            make.centerY.equalTo(self);
        }];
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.indicator.mas_right).offset(10);
            make.right.equalTo(@(-kPading_LeftRight));
            make.centerY.equalTo(self);
        }];
    }
    else{
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kPading_LeftRight));
            make.right.equalTo(@(-kPading_LeftRight));
            make.centerY.equalTo(self);
        }];
    }
    
    [super updateConstraints];
}

- (void)updateIndicators {
    UIView *indicator = self.indicator;
    BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
    
    FRMessageHUDMode mode = self.mode;
    FRMessageHUDType type = self.type;
    if (mode == FRMessageHUDModeIndicator && type == FRMessageHUDTypeNormal) {
        if (!isActivityIndicator) {
            // Update to indeterminate indicator
            [indicator removeFromSuperview];
            indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.indicatorSize.width, self.indicatorSize.height)];
            [(UIActivityIndicatorView *)indicator startAnimating];
            [self addSubview:indicator];
        }
    }
    else {
        [indicator removeFromSuperview];
        indicator = nil;
    }
    self.indicator = indicator;
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Show & hide
- (void)showAnimated:(BOOL)animated {
    [self.superview layoutIfNeeded];
    
    self.useAnimation = animated;
    self.finished = NO;
    
    [self showUsingAnimation:self.useAnimation];
}

- (void)hideAnimated:(BOOL)animated {
    self.useAnimation = animated;
    self.finished = YES;
    
    [self hideUsingAnimation:self.useAnimation];
}

- (void)showUsingAnimation:(BOOL)animated {
    [self.hideDelayTimer invalidate];
    
    if (animated) {
        [self animateIn:YES completion:^(BOOL finished) {
        }];
    } else {
        self.alpha = 1.0;
        self.layer.transform = CATransform3DMakeTranslation(0, kYPMessageTopToVCFinalConstant, 0);
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    if (animated) {
        [self animateIn:NO completion:^(BOOL finished) {
            [self done];
        }];
    } else {
        [self done];
    }
}

- (void)done {
    [self.hideDelayTimer invalidate];
    
    if (self.hasFinished) {
        self.alpha = 0.0f;
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
    }
    FRMessageHUDCompletionBlock completionBlock = self.completionBlock;
    if (completionBlock) {
        completionBlock();
    }
}

- (void)animateIn:(BOOL)animatingIn completion:(void(^)(BOOL finished))completion {
    
    double durationWithAnimate = animatingIn?kYPMessageAnimationDuration+0.2f:kYPMessageAnimationDuration;
    
    // Perform animations
    
    dispatch_block_t animations = ^{
        if(animatingIn){
            self.alpha = 1.0;
            self.layer.transform = CATransform3DMakeTranslation(0, kYPMessageTopToVCFinalConstant, 0);
        }
        else{
            self.alpha = 0.1f;
            self.layer.transform = CATransform3DMakeTranslation(0, -kYPMessageTopToVCFinalConstant, 0);
        }
    };
    
    // Spring animations are nicer, but only available on iOS 7+
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 || TARGET_OS_TV
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        if(animatingIn){
            [UIView animateWithDuration:durationWithAnimate
                                  delay:0.
                 usingSpringWithDamping:0.8f
                  initialSpringVelocity:10.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:animations
                             completion:completion];
        }
        else{
            [UIView animateWithDuration:durationWithAnimate
                             animations:animations
                             completion:completion];
        }
        
        return;
    }
#endif
    [UIView animateWithDuration:durationWithAnimate delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

#pragma mark - Timer callbacks
- (void)handleHideTimer:(NSTimer *)timer {
    [self hideAnimated:[timer.userInfo boolValue]];
}

@end

@implementation FRMessageConfig

+(instancetype)shared{
    static FRMessageConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FRMessageConfig new];
    });
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        _tipMessageDuration = 2.0f;
        
        _normalColor = [UIColor colorWithHexString:@"00C060"];
        _warningColor = [UIColor colorWithHexString:@"FFCC00"];
        _errorColor = [UIColor colorWithHexString:@"FF2D55"];
        _successColor = _normalColor;
    }
    return self;
}

-(void)setTipMessageDuration:(NSTimeInterval)tipMessageDuration{
    _tipMessageDuration = tipMessageDuration;
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}

-(void)setWarningColor:(UIColor *)warningColor{
    _warningColor = warningColor;
}

-(void)setErrorColor:(UIColor *)errorColor{
    _errorColor = errorColor;
}

-(void)setSuccessColor:(UIColor *)successColor{
    _successColor = successColor;
}

@end
