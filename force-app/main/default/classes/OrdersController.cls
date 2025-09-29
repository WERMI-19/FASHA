/**
 * @description Controller Apex pour composants LWC. Le 'without sharing' est utilisé
 * pour garantir que le calcul du total inclut toutes les commandes pertinentes.
 */
public without sharing class OrdersController {
    /**
     * @description Calcule la somme des commandes activées pour un compte donné.
     * @param accountId L'ID du compte client.
     * @return Le montant total (Decimal) ou 0 si aucun.
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        if (accountId == null){
            return 0;
        }

        // Vérification des permissions de lecture sur l'objet Order
        if (!Schema.sObjectType.Order.isAccessible()) {
            return 0;
        }

        // Vérification des permissions sur les champs
        if (!Schema.sObjectType.Order.fields.TotalAmount.isAccessible() ||
            !Schema.sObjectType.Order.fields.AccountId.isAccessible() ||
            !Schema.sObjectType.Order.fields.Status.isAccessible()) {
            return 0;
        }

        AggregateResult[] results = [
            SELECT SUM(TotalAmount) total FROM Order WHERE AccountId = :accountId AND Status = 'Activated'WITH SECURITY_ENFORCED];  // Clause de sécurité
        return (Decimal)(results[0].get('total') != null ? results[0].get('total') : 0);
    }
}