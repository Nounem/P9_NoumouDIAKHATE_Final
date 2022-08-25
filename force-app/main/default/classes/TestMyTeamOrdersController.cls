/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class TestMyTeamOrdersController 
{
    @TestSetup
    static void makeData(){
        Account acc = TestDataFactory.createAccount2('TestAccount1');
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(200, acc.Id); 
    }

    @isTest
    static void myTeamOrdersController(){

        // for to loop 

        List<Order> ordersListToUpdate = new List<Order>();

        for(Order ord : [SELECT Id, ShipmentCost__c, TotalAmount,NetAmount__c 
                          FROM Order 
                         WHERE Account.Name = 'TestAccount1'])
        {

            ord.Status= 'Ordered';
            ordersListToUpdate.add(ord);
        }

        Test.startTest();

        update ordersListToUpdate; 
        MyTeamOrdersController myteam = new myTeamOrdersController();

        System.debug('myteam'+myteam.aggregateResultList);

        System.assertEquals(myteam.aggregateResultList.size(), 1);
       
        Test.stopTest();  


    }
   

}
