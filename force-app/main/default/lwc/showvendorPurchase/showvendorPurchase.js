import { LightningElement,wire } from 'lwc';
import getPurchaseOrders from '@salesforce/apex/PurchaseController.getPurchaseOrders'

export default class ShowvendorPurchase extends LightningElement {


    selectedVendorId;
    purchaseList = [];
    totalAmount = 0;

    columns = [
        { label: 'Order Name', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Amount', fieldName: 'Total_Amount__c', type: 'currency' }
    ];

    
    @wire(getPurchaseOrders, { vendorId: '$selectedVendorId' })
    wiredOrders({ data, error }) {
        if (data) {
            this.purchaseList = data;

            this.totalAmount = data.reduce((sum, rec) => {
                return sum + (rec.Total_Amount__c || 0);
            }, 0);
        } else if (error) {
            console.error(error);
        }
    }

    handleVendorChange(event) {
        this.selectedVendorId = event.detail.value;
    }

}   