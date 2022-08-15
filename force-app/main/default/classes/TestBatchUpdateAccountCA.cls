/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-14-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestBatchUpdateAccountCA 
{
  @TestSetup
  static void makeData()
  {
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
        //  Id batchId = Database.executeBatch(batchCA); //executer le batch 
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
}
