import { LightningElement, api, wire } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/OrdersController.getSumOrdersByAccount';

export default class AccountOrdersSummary extends LightningElement {

    @api recordId;
    sumOrdersOfCurrentAccount;
    error;
    
    // Utilisation de @wire pour appeler la méthode Apex de manière réactive
    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredSumOrders({ error, data }) {
        if (data) {
            this.sumOrdersOfCurrentAccount = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.sumOrdersOfCurrentAccount = undefined;
        }
    }
    get hasPositiveAmount() {
        return this.sumOrdersOfCurrentAccount && this.sumOrdersOfCurrentAccount > 0;
    }
}