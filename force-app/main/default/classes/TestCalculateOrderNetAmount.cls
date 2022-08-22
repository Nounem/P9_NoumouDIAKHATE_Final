/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-21-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestCalculateOrderNetAmount 
{
    @TestSetup
    static void makeData(){
        TestDataFactory.createAccounts(5);
    }

    @isTest
    static void NetAmountForOrderTest() 
    {

      /**   Account acc = [SELECT Id, Name
                        FROM Account 
                        WHERE Account.Name = 'TestAccount1'
                    ];*/

        Order order = [SELECT Id, ShipmentCost__c, TotalAmount,NetAmount__c 
                       FROM Order 
                       WHERE Account.Name = 'TestAccount1'
                    ];
        
        order.shipmentCost__c = 100;
        decimal netToTest = order.TotalAmount - order.shipmentCost__c;
        System.debug('netToTest'+netToTest);

        Test.startTest();
        update(order);
        Test.stopTest();
        
        //21900 = 1 Order * 22000 UnitPrice - 100 shipmentCost
        Order netCalculated = [SELECT NetAmount__c FROM Order WHERE Account.Name = 'TestAccount1'];
        System.assertEquals(netCalculated.NetAmount__c, netToTest);
        
    }



      


}