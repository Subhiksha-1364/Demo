import { LightningElement, wire,api } from 'lwc';
import lastName from '@salesforce/schema/Contact.LastName';
import email from '@salesforce/schema/Contact.Email';
import age from '@salesforce/schema/Contact.Age__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { getRecord,getFieldValue} from 'lightning/uiRecordApi';

export default class WireHandsOn extends LightningElement {

@api recordId

    @wire(getRecord, { recordId: '$recordId', fields: [lastName, email, age] })

    /*contactDetailFn({data,error})
    {
        if(data)
        {
            console.log(data);
        }
        else if(error)
        {
            console.log(error);
        }
    } */

    contactDetailProperty

    get contactEmail()
    {
        return getFieldValue(this.contactDetailProperty.data,email)
    }



    checkEligibility() {
        if (this.contactDetailProperty.data.fields.Age__c.value >= 18) {
            const successToast = new ShowToastEvent({
                title: 'Eligible',
                message: 'Contact Eligible',
                variant: 'success'
            })
            this.dispatchEvent(successToast)

        }
        else {
            const errorToast = new ShowToastEvent({
                title: 'Not Eligible',
                message: 'Contact Not Eligible',
                variant: 'error'

            })
            this.dispatchEvent(errorToast)
        }
    }
}