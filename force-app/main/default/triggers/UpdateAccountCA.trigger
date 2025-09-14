trigger UpdateAccountCA on Order (after insert, after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        OrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    // Nous ajouterons la logique pour l'insertion plus tard si besoin.
}