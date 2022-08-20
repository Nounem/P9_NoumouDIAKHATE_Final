/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-20-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestUpdateAccountCA 
{
    @TestSetup
    static void makeData(){
        TestDataFactory.createAccounts(5);
    }

    @isTest
    static void TestCalculateAmount()
    {
        
        Test.startTest();
            List<OrderItem> ordItem = [SELECT Id, Quantity, OrderId,Order.AccountId 
                                        FROM OrderItem 
                                        WHERE Order.Account.Name LIKE 'TestAccount%'
                                        ];

            List<Order>  oldOrderResult = [SELECT Id, OrderNumber, AccountId, TotalAmount,
                                          Status,NetAmount__c, ShipmentCost__c, EffectiveDate
                                      FROM Order
                                      WHERE Id = :ordItem[0].OrderId];
            System.assertEquals(22000, oldOrderResult[0].TotalAmount);
           // System.assertEquals(21980, oldOrderResult[0].NetAmount__c); // 22000 - 20 

            Account result = [SELECT Id, Chiffre_d_affaire__c
                             FROM Account
                             WHERE Id =: ordItem[0].Order.AccountId ];   

            System.assertEquals(22000, result.Chiffre_d_affaire__c);

        Test.stopTest();
        }
 
}