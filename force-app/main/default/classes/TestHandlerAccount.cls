/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-22-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestHandlerAccount 
{
    @TestSetup
    static void makeData(){
        TestDataFactory.createAccounts(700);
    }

@isTest
static void TestUpdateAccountTotalRevenue()
{
      
    Test.startTest();
          List<Account> scope = [SELECT Id,Chiffre_d_affaire__c
                                 FROM Account 
                                 WHERE Name LIKE 'TestAccount%' ];
          
          BatchUpdateAccountsCA batchCA = new BatchUpdateAccountsCA();
        
          Database.QueryLocator ql = batchCA.start(null);
          batchCA.execute(null, scope);
          batchCA.finish(null);
        
          List<Account> result =[
                                  SELECT Id,Name,Chiffre_d_affaire__c 
                                  FROM Account 
                                  WHERE Id IN (SELECT AccountId FROM Order WHERE Status='Ordered')
                                ];
    Test.stopTest();
        for(Account acct : result)
        {
        system.assertEquals(44000,acct.Chiffre_d_affaire__c,'Result should be 44000');
        //Vérifiez que tous les comptes "chiffre d'affaire" ayant une commande avec le statut "Commandé" ont été mis à jour.
        }  

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

       // System.debug('orderListUpdate'+ordersListToUpdate);
       // System.debug('orderListUpdate'+ordersListToUpdate[0].NetAmount__c);

        System.assertEquals(22000, ordersListToUpdate[0].TotalAmount) ; 
     
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



    

}
