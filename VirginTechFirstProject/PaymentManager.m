//
//  PaymentManager.m
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/05/28.
//
//

#import "PaymentManager.h"
#import "GameManager.h"

@implementation PaymentManager

UIAlertView* mAlert;
SKProduct* product_;

-(BOOL)buyProduct:(SKProduct*)product{
    
    //NSLog(@"%@",product.localizedTitle);
    product_=product;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //端末設定チェック
    if([SKPaymentQueue canMakePayments]==NO){
        return NO;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    return YES;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            // 購入処理中
            /*
             * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
             */
            mAlert = [[UIAlertView alloc] initWithTitle:@"購入処理中..."
                                                message:nil
                                                delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
            [mAlert show];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            indicator.center = CGPointMake(mAlert.bounds.size.width * 0.5f, mAlert.bounds.size.height * 0.5f +10);
            [indicator startAnimating];
            [mAlert addSubview:indicator];
            
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            // 購入処理成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完了しました。"
                                                message:[NSString stringWithFormat:
                                                         @"%@%@",product_.localizedTitle,@"を購入しました。"]
                                                delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
            [alert show];
            /*
             * ここでレシートの確認やアイテムの付与を行う。
             */
            [self bought:product_.productIdentifier];

            [queue finishTransaction:transaction];
            
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            [queue finishTransaction:transaction];
            // エラーが発生したことをユーザに知らせる
            if (transaction.error.code == SKErrorUnknown) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                message:[transaction.error localizedDescription]
                                                delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            // リストア処理完了
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"リストア完了。"
                                                    message:[NSString stringWithFormat:
                                                             @"%@%@",product_.localizedTitle,@"を購入しました。"]
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
            [alert show];
            /*
             * アイテムの再付与を行う
             */
            [self bought:product_.productIdentifier];
            
            [queue finishTransaction:transaction];
        } else {
            [queue finishTransaction:transaction];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 途中で止まった処理を再開する Consumable アイテムにも有効
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // 全てのリストア処理が終了
}

//終了処理
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [mAlert dismissWithClickedButtonIndex:0 animated:NO];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)bought:(NSString*)productIds
{
    
    if([productIds isEqualToString:@"VirginTechFirstProject_Jewel10Pack"]){

    }else if([productIds isEqualToString:@"VirginTechFirstProject_Jewel10Pack"]){
        
    }else if([productIds isEqualToString:@"VirginTechFirstProject_Jewel10Pack"]){
        
    }
    NSLog(@"%@",productIds);
}

@end
