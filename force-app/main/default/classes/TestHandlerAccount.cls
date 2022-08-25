/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestHandlerAccount 
{
    @TestSetup
    static void makeData(){
        Account acc = TestDataFactory.createAccount2('TestAccount1');
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(200, acc.Id); 
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
        system.assertEquals(40000,acct.Chiffre_d_affaire__c,'Result should be 40000');
        System.debug('acct.Chiffre_d_affaire__c '+acct.Chiffre_d_affaire__c);
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
        System.debug('ordItem -- '+ordItem);

        List <Order> ordersListToUpdate = new List <Order>();

        Decimal SomTotalAmount =0; 
        Decimal netToTest =0;
        Decimal SomNetShipmentCost = 0;  
       
        
        for(Order ord : [SELECT AccountId, ShipmentCost__c,TotalAmount,NetAmount__c 
                        FROM Order 
                        WHERE Account.Name = 'TestAccount1' ]) 
        {
            ord.Status = 'Ordered';
            ordersListToUpdate.add(ord);

            System.debug('shipcost'+ ord.ShipmentCost__c);

            SomTotalAmount += ord.TotalAmount;
            SomNetShipmentCost += ord.ShipmentCost__c ; 
            netToTest = SomTotalAmount - SomNetShipmentCost;

        }

        Test.startTest();
        update ordersListToUpdate; 
        Test.stopTest();  

        //  (200 orders * 200 unitprice)- 500*20 = 36000

       
        System.assertEquals(40000,  SomTotalAmount) ; 
        System.debug('result SomTotalAmount '+ SomTotalAmount);


        System.assertEquals(4000 ,SomNetShipmentCost);
        System.debug('SomNetShipmentCost -- '+SomNetShipmentCost);


        System.debug('netToTest '+netToTest);
        System.assertEquals(36000 ,netToTest);

    }



    

}
