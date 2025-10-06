/**
 * @description Trigger unique pour l'objet Order.
 * Délègue toute la logique à la classe OrderTriggerHandler.
 */
trigger OrderTrigger on Order (before insert, before update, after insert, after update) {
         // Logique BEFORE : le calcul du NetAmount__c
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            // Appelle la méthode pour la logique "before"
            OrderTriggerHandler.handleBeforeInsertUpdate(Trigger.new);
        }
    }
           //Logique AFTER : le recalcul du Chiffre_d_affaire__c sur le Compte
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            // Appelle la méthode pour la logique "after"
            OrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}