trigger assignEntitlementToCase on Case (after insert, after update) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        AssignEntitlementToCaseHelper.assignEntitlement();
    }
}