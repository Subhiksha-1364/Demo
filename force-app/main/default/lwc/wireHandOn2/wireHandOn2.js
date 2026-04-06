import { LightningElement,api,wire } from 'lwc';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
/* import Contact_Obj from '@salesforce/schema/Contact'; */

export default class WireHandOn2 extends LightningElement {

    @api objectApiName

    fieldArray =[];

    customCount=0;

    FieldCount=0;

    fieldValue={};

    requiredCount;

    @wire(getObjectInfo,{objectApiName:'$objectApiName'})

    ObjectInfo({data,error})
    {
         console.log('wire called');
        if(data){

            console.log('data',data);
            this.fieldArray = Object.keys(data.fields);

            this.FieldCount=this.fieldArray.length;

            this.fieldValue= Object.values(data.fields)

           this.customCount = this.fieldValue.filter(field => field.custom).length;

           this.requiredCount = this.fieldValue.filter(field => field.required).length;
         }   
        else if(error)
            {
                console.log('error',error);
            }    
        
    }

    connectedCallback() {
    console.log('objectApiName:', this.objectApiName);
}



}