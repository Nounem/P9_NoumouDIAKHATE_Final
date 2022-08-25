/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class HandlerAccount
{
    public static void updateTotalRevenue(List<Account> scope) 
    {
        Map<Id, Account> accountIdMap = new Map<Id, Account>();
        for (Account acc_scope : scope) {
            accountIdMap.put(acc_scope.Id, acc_scope);
            
        }
        
        Map<Id,AggregateResult> sumOfTotalAmount = new Map<Id,AggregateResult>([
                                                    SELECT AccountId Id, SUM(TotalAmount) total 
                                                    FROM Order 
                                                    WHERE AccountId IN :accountIdMap.keySet() AND AccountId != null 
                                                    GROUP BY AccountId
                                                    ]);

        List<Account> acctsToUpdate = new List<Account>();
       
        for (Account account : scope) 
        {   
            Decimal amount = (Decimal)sumOfTotalAmount.get(account.Id).get('total');
            account.Chiffre_d_affaire__c =( account.Chiffre_d_affaire__c != null)?account.Chiffre_d_affaire__c + amount:0;
            acctsToUpdate.add(account);
        }
         if(acctsToUpdate.size() > 0)
             // Update the database
            update acctsToUpdate;         
    }

    public static void updateAccountCA (Map<Id,order> orderNewMap)
    {
       
        set<id> ids=new set<id>();
        Map<ID, Decimal> amountMap = new Map<ID, Decimal>();
 
        for(order ord: orderNewMap.values())
        {
            if(ord.Status =='Ordered'){
                amountMap.put(ord.AccountId, ord.TotalAmount);
                ids.add(ord.AccountId);

            }
            
        } 
        List<Account> accountsToUpdate=new List<Account>();
        List<Account> accountList = new List<Account>([
                                                      SELECT id,Chiffre_d_affaire__c 
                                                      FROM Account 
                                                      WHERE id in :ids      
                                                  ]);

        for(Account acc: accountList)
        {
            Decimal ca = ( acc.Chiffre_d_affaire__c != null)?acc.Chiffre_d_affaire__c + amountMap.get(acc.Id):0;
            acc.Chiffre_d_affaire__c = (ca < 0)?0:ca;
            accountsToUpdate.add(acc);            
        } 
        if(accountsToUpdate.size()>0)
        {
            update accountsToUpdate;
        }
    }

    public static void updateNetAmount(List<order> orderNew)
    {

        for(order ord: orderNew)
        {
            ord.NetAmount__c = ord.ShipmentCost__c == null?ord.TotalAmount: ord.TotalAmount - ord.ShipmentCost__c; 
            System.debug('trigger netAmount '+ord.NetAmount__c);
        } 
    }

}