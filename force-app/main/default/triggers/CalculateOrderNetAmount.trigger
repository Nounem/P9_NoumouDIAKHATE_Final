/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-20-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalculateOrderNetAmount on Order (before update) 
{
    //Iterate on each new order
    for (Order newOrder : Trigger.new) {
        
        newOrder.NetAmount__c = newOrder.ShipmentCost__c == null ? newOrder.TotalAmount: newOrder.TotalAmount - newOrder.ShipmentCost__c;
    }

}