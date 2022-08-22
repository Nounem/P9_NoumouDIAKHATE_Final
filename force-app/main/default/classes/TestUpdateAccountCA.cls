/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-21-2022
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

        List<OrderItem> ordItem = [SELECT Id, Quantity, OrderId,Order.AccountId 
        FROM OrderItem 
        WHERE Order.Account.Name = 'TestAccount1'
        ];

        List <Order> ordersListToUpdate = new List <Order>();
        // lutter contre governer limit (for to loop)
        for(Order ord : [SELECT AccountId, ShipmentCost__c,TotalAmount,NetAmount__c 
                        FROM Order 
                        WHERE Account.Name = 'TestAccount1' ]) 
        {
            ord.Status = 'Ordered';
            ordersListToUpdate.add(ord);
        }

        Test.startTest();
        update ordersListToUpdate; 
        Test.stopTest();  

        System.debug('orderListUpdate'+ordersListToUpdate);
        System.debug('orderListUpdate'+ordersListToUpdate[0].NetAmount__c);

        System.assertEquals(22000, ordersListToUpdate[0].TotalAmount) ; 
       // System.assertEquals(10, netShipmentCost) ;
      //  System.assertEquals(21990 ,netToTest);

      Account result = [SELECT Id, Chiffre_d_affaire__c
                             FROM Account
                             WHERE Id =: ordItem[0].Order.AccountId ];  

     System.assertEquals(22000 ,result.Chiffre_d_affaire__c);

    List<Order> resultOrder = [SELECT AccountId, ShipmentCost__c,TotalAmount,NetAmount__c 
                        FROM Order 
                        WHERE Account.Name = 'TestAccount1' ];

    System.debug('NetAmount__c'+resultOrder[0].NetAmount__c);
    System.assertEquals(21980 ,resultOrder[0].NetAmount__c);



    }
      /**   
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
        */
 
}