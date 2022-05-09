//
//  YXAgreementAlertView.h
//  MuchProj
//
//  Created by Augus on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 协议弹窗点击类型 */
typedef NS_ENUM(NSUInteger, YXAgreementAlertVType) {
    /** 同意 */
    YXAgreementAlertVTypeSure,
    /** 不同意并退出 */
    YXAgreementAlertVTypeNotSure,
    /** 用户协议 */
    YXAgreementAlertVTypeAgreement,
    /** 隐私协议 */
    YXAgreementAlertVTypePolicyVC,
};

typedef void(^YXAgreementAlertVBlock)(YXAgreementAlertVType type);

@interface YXAgreementAlertView : UIView

@property (nonatomic, weak) YXBaseVC *baseVC;
@property (nonatomic, weak) TYAlertController *alertController;
@property (nonatomic, copy) YXAgreementAlertVBlock yxAgreementAlertVBlock;

@end

NS_ASSUME_NONNULL_END
