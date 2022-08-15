/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class BatchUpdateAccountsCA implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext info)
    { 
        
      return Database.getQueryLocator(
            [
                SELECT Id
                FROM Account
                WHERE
                    Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')
            ]
        );

   }
   
   global void execute(Database.BatchableContext info, List<Account> scope)
   { 
        HandlerAccount.updateTotalRevenue(scope);
   }    
   global void finish(Database.BatchableContext info){}     
   
}
