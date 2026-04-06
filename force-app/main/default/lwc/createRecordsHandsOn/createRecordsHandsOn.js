import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import  ACCOUNT_OBJECT  from  '@salesforce/schema/Account';
import ACC_NAME  from '@salesforce/schema/Account.Name';
import ACC_REV from '@salesforce/schema/Account.AnnualRevenue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreateRecordsHandsOn extends LightningElement {

    accName
    annualRev

    handleChange(event) {
        if (event.target.name === 'Name') {
            this.accName = event.target.value
        }
        else if (event.target.name === 'AnnualRevenue') {
            this.annualRev = event.target.value
        }
    }

    createRecordHandler() {
        const accfields = {};
        accfields[ACC_NAME.fieldApiName] = this.accName;
        accfields[ACC_REV.fieldApiName] = this.annualRev;

        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields: accfields };
        createRecord(recordInput)
            .then(result => {
                console.log('Record created', result);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Account created',
                    variant: 'success'
                }))
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                }))
            })

    }
}