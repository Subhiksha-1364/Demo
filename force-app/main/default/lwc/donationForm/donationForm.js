import { LightningElement } from 'lwc';
import DonatorObj from '@salesforce/schema/Donator__c';
import paymentObj from '@salesforce/schema/Payment_Datails__c'
import DName from '@salesforce/schema/Donator__c.Donator_Name__c';
import DAmount from '@salesforce/schema/Donator__c.Donation_Amount__c';
import DEmail from '@salesforce/schema/Donator__c.Email__c';
import DPhone from '@salesforce/schema/Donator__c.Phone_number__c';
import DAge from '@salesforce/schema/Donator__c.Age__c';
import DAddress from '@salesforce/schema/Donator__c.Address__c';
import DonatorField from '@salesforce/schema/Payment_Datails__c.Donator__c'
import DonationField from '@salesforce/schema/Payment_Datails__c.Amount__c'
import StatusField from '@salesforce/schema/Payment_Datails__c.Status__c'

import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import generatePaymentLink from '@salesforce/apex/PaymentController.generatePaymentLink'

export default class DonationForm extends LightningElement {

    Donator
    age
    phone
    email
    address
    amount

    connectedCallback() {
        const params = new URLSearchParams(window.location.search);

        if (params.get('status') === 'success') {
            this.createRecords(params);
        }
    }

    handleChange(event) {
        if (event.target.name === 'DonorName') {
            this.Donator = event.target.value;
        } else if (event.target.name === 'DonationAmount') {
            this.amount = event.target.value;
        } else if (event.target.name === 'Email') {
            this.email = event.target.value;
        } else if (event.target.name === 'Phone') {
            this.phone = event.target.value;
        } else if (event.target.name === 'Age') {
            this.age = event.target.value;
        }
        else if (event.target.name === 'Address') {
            this.address = event.target.value;
        }

    }

    createDonationHandler() {

        generatePaymentLink({
            name: this.Donator,
            amount: this.amount,
            email: this.email,
            address: this.address,
            phone: this.phone,
            age: this.age
        })

            .then(link => {


                this.dispatchEvent(new ShowToastEvent({

                    title: 'Redirecting....',
                    message: 'Please wait while we generate your payment link.',
                    variant: 'info'
                }))
                window.open(link, '_self'); // ✅ redirect

            })
            .catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body ? error.body.message : error.message,
                    variant: 'error'
                }));
            });
    }

    createRecords(params) {

        const donorFields = {};
        donorFields[DName.fieldApiName] = params.get('name');
        donorFields[DAmount.fieldApiName] = params.get('amount');
        donorFields[DEmail.fieldApiName] = params.get('email');
        donorFields[DPhone.fieldApiName] = params.get('phone');
        donorFields[DAge.fieldApiName] = params.get('age');
        donorFields[DAddress.fieldApiName] = params.get('address');

        createRecord({ apiName: DonatorObj.objectApiName, fields: donorFields })
            .then(donor => {

                const paymentFields = {};
                paymentFields[DonatorField.fieldApiName] = donor.id;
                paymentFields[DonationField.fieldApiName] = params.get('amount');
                paymentFields[StatusField.fieldApiName] = 'Paid';

                return createRecord({ apiName: paymentObj.objectApiName, fields: paymentFields });

                
            })
            .then(() => {

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Donation made successfully 🎉',
                    variant: 'success'
                }));

                // clean URL
                window.history.replaceState({}, document.title, window.location.pathname);

            })
            .catch(error => {
                console.error(error);
            });
    }











    /* .then(result => {
         console.log('Donation record created', result);
         this.Donator = '';
         this.amount = '';
         this.email = '';
         this.phone = '';
         this.age = '';
         this.address = '';



     })
     .catch(error => {
         console.error('Error creating donation record', error);
         this.dispatchEvent(new ShowToastEvent({
             title: 'Error',
             message: 'Donation failed: ' + error.body.message,
             variant: 'error'
         }))

     });
}*/

}

