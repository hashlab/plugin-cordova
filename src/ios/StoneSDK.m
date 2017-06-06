#import "StoneSDK.h"

@implementation StoneSDK

- (void)validation:(CDVInvokedUrlCommand*)command {

    // Recebe o Stone Code
    NSString* stoneCodeList = [[command arguments] objectAtIndex:0];

    // Ativando o Stone Code;
    [STNStoneCodeActivationProvider activateStoneCode:stoneCodeList withBlock:^(BOOL succeeded, NSError *error) {
        CDVPluginResult* result;
        if (succeeded) {
            NSString* msg = @"Stone Code ativado com sucesso.";
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        } else {
            NSString* msg = error.description;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)device:(CDVInvokedUrlCommand*)command {

    // Efetua a conexão com o pinpad
    [STNPinPadConnectionProvider connectToPinpad:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *success = [[UIAlertView alloc]
                                    initWithTitle:@"Ativado!"
                                    message:@"Pareado com sucesso!"
                                    delegate:self
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
            [success show];
        } else {
            NSString* msg = error.description;
            UIAlertView *fail = [[UIAlertView alloc]
                                 initWithTitle:@"Oops!"
                                 message:msg
                                 delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
            [fail show];
        }
    }];
}

- (void)transaction:(CDVInvokedUrlCommand*)command {

    // Recebe o valor do Plugin
    NSString* amount = [[command arguments] objectAtIndex:0];

    /*
     O valor da transação deve ser sempre por CENTAVOS e para isso
     devemos utilizar com um int no objeto da transação;
     */
    float realValue = [self convertToFloat:amount] / 100;
    float centsFromFloatValue = 100 * realValue;
    int justCents = (int) centsFromFloatValue;

    // Iniciando o modelo transaction para efetivar a transacao;
    STNTransactionModel *transaction = [[STNTransactionModel alloc] init];

    // Propriedade Obrigatória, deve conter o valor da transação em centavos. (EX. R$ 56,45 = 5645);
    transaction.amount = [NSNumber numberWithInteger:justCents];

    // Recebe o método de pagamento do Plugin
    NSString* method = [[command arguments] objectAtIndex:1];

    // Recebe o numero de parcelas do Plugin
    NSString* instalments = [[command arguments] objectAtIndex:2];

    // Verifica se é DÉBITO ou CRÉDITO.
    if ([method  isEqual: @"DEBIT"]) { // é Débito
        instalments = @"1";
        int intInstalments = [instalments integerValue];

        // Propriedade Obrigatória, define o número de parcelas da transação;
        transaction.instalmentAmount = intInstalments;

        // Propriedade Obrigatória, define o tipo de transação, se é débito ou crédito;
        transaction.type = STNTransactionTypeSimplifiedDebit;

    } else if ([method  isEqual: @"CREDIT"]) { // é Crédito
        // Propriedade Obrigatória, define o tipo de transação, se é débito ou crédito;
        transaction.type = STNTransactionTypeSimplifiedCredit;

        if ([instalments isEqual: @"ONE_INSTALMENT"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountOne;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"ONE_INSTALMENT");
        } else if ([instalments isEqual: @"TWO_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTwo;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"TWO_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"THREE_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountThree;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"THREE_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"FOUR_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountFour;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"FOUR_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"FIVE_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountFive;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"FIVE_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"SIX_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountSix;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"SIX_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"SEVEN_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountSeven;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"SEVEN_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"EIGHT_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountEight;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"EIGHT_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"NINE_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountNine;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"NINE_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"TEN_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTen;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"TEN_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"ELEVEN_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountEleven;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"ELEVEN_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"TWELVE_INSTALMENT_NO_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTwelve;
            transaction.instalmentType = STNInstalmentTypeNone;
            NSLog(@"TWELVE_INSTALMENT_NO_INTEREST");
        } else if ([instalments isEqual: @"TWO_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTwo;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"TWO_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"THREE_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountThree;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"THREE_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"FOUR_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountFour;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"FOUR_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"FIVE_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountFive;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"FIVE_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"SIX_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountSix;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"SIX_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"SEVEN_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountSeven;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"SEVEN_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"EIGHT_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountEight;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"EIGHT_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"NINE_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountNine;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"NINE_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"TEN_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTen;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"TEN_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"ELEVEN_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountEleven;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"ELEVEN_INSTALMENT_WITH_INTEREST");
        } else if ([instalments isEqual: @"TWELVE_INSTALMENT_WITH_INTEREST"]) {
            transaction.instalmentAmount = STNTransactionInstalmentAmountTwelve;
            transaction.instalmentType = STNInstalmentTypeMerchant;
            NSLog(@"TWELVE_INSTALMENT_WITH_INTEREST");
        } else {
            NSLog(@"Escolha uma opção válida");
        }
    } else {
        NSLog(@"Opção Inválida");
    }

    // Vamos efetivar a transacao;
    [STNTransactionProvider sendTransaction:transaction withBlock:^(BOOL succeeded, NSError *error) {
        CDVPluginResult* result;
        if (succeeded) {
            NSString* msg = @"Transacao realizada com sucesso!";
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        } else {
            NSString* msg = error.description;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

- (float)convertToFloat:(NSString*)fromFormatedString {
    NSMutableString *textFieldStrValue = [NSMutableString stringWithString:fromFormatedString];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];

    [textFieldStrValue replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0, [textFieldStrValue length])];

    // Muda o separador decimal para ponto caso esteja numa localidade que use vírgula.
    [textFieldStrValue replaceOccurrencesOfString:numberFormatter.decimalSeparator
                                       withString:@"."
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0, [textFieldStrValue length])];

    float textFieldNum = [[NSDecimalNumber decimalNumberWithString:textFieldStrValue] floatValue];

    return textFieldNum;
}

- (void)transactionList:(CDVInvokedUrlCommand*)command {

    NSArray *transactions = [STNTransactionListProvider listTransactions];

    STNTransactionModel *transactionInfoProvider = [transactions objectAtIndex:0];
    NSLog(@"transactionInfoProvider, %@", transactionInfoProvider);

    // Tratamento do amount somente para exibição.
    int centsValue = [transactionInfoProvider.amount intValue];
    float realValue = centsValue*0.01;
    NSString *amount = [NSString stringWithFormat:@"%.02f", realValue];

    // Tratamento do status.
    NSString *shortStatus;
    if ([transactionInfoProvider.statusString isEqual: @"Transação Aprovada"]) {
        shortStatus = @"Aprovada";
    } else if ([transactionInfoProvider.statusString isEqual:@"Transação Cancelada"]) {
        shortStatus = @"Cancelada";
    } else {
        shortStatus = transactionInfoProvider.statusString;
    }

    NSString * date = transactionInfoProvider.dateString;

    NSString *idTransaction = [NSString stringWithFormat: @"R$ %@\n%@\n%@", amount, shortStatus, date];

    NSArray *msg = [NSArray arrayWithObjects:idTransaction, nil];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsArray:msg];

    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)transactionCancel:(CDVInvokedUrlCommand*)command {
    NSArray *transactions = [STNTransactionListProvider listTransactions];

    STNTransactionModel *transactionInfoProvider = [transactions objectAtIndex:0];

    [STNCancellationProvider cancelTransaction:transactionInfoProvider withBlock:^(BOOL succeeded, NSError *error) {
        CDVPluginResult* result;
        if (succeeded) {
            NSString* msg = @"Transação cancelada!";
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        } else {
            NSString* msg = error.description;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

- (void)tablesDownload:(CDVInvokedUrlCommand*)command {

    [STNTableDownloaderProvider downLoadTables:^(BOOL succeeded, NSError *error) {
        CDVPluginResult* result;
        if (succeeded) {
            NSString* msg = @"Download Realizado!";
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        } else {
            NSString* msg = error.description;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

- (void)tablesUpdate:(CDVInvokedUrlCommand*)command {

    /* Antes de efetivar o carregamento das tabelas é necessário
     que seja efetivado a conexão com o pinpad. */

    [STNPinPadConnectionProvider connectToPinpad:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *success = [[UIAlertView alloc]
                                    initWithTitle:@"Ativado!"
                                    message:@"Stone Code ativado com sucesso!"
                                    delegate:self
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
            [success show];
        } else {
            NSString* msg = error.description;
            UIAlertView *fail = [[UIAlertView alloc]
                                 initWithTitle:@"Oops!"
                                 message:msg
                                 delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
            [fail show];
        }
    }];

    // Agora vamos fazer o carregamento das tabelas;
    [STNTableLoaderProvider loadTables:^(BOOL succeeded, NSError *error) {
        CDVPluginResult* result;
        if (succeeded) {
            NSString* msg = @"Tabelas atualizadas!";
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:msg];
        } else {
            NSString* msg = error.description;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

@end
