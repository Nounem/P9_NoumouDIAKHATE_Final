/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-21-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalculateOrderNetAmount on Order (before update) 
{
    HandlerAccount.updateNetAmount(Trigger.new);
    System.debug('Trigger.new'+Trigger.new);
}