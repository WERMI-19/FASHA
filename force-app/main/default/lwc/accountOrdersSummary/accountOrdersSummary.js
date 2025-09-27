import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getSumOrdersByAccount from '@salesforce/apex/OrdersController.getSumOrdersByAccount';
//fonctions nécessaires importeés

export default class AccountOrdersSummary extends LightningElement {

    @api recordId;
    sumOrdersOfCurrentAccount; //stocke la somme des montants des commandes récupérés depuis aPEX
    error;
    wiredSumOrdersResult;// pour stocker le résultat complet du @wire afin de pouvoir le rafraîchir

    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredSumOrders(result) {
        // On stocke le résultat complet du @wire
        this.wiredSumOrdersResult = result;
        if (result.data) {
            this.sumOrdersOfCurrentAccount = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.sumOrdersOfCurrentAccount = undefined;
        }
    }
    
    get hasPositiveAmount() {
        return this.sumOrdersOfCurrentAccount && this.sumOrdersOfCurrentAccount > 0;
    }

    //  fonction pour gérer le clic sur le bouton
    handleRefresh() {
        // Appelle refreshApex pour rafraîchir les données du @wire
        return refreshApex(this.wiredSumOrdersResult);
    }
}