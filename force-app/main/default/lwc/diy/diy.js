import { LightningElement, track } from 'lwc';

export default class Diy extends LightningElement {

        
            firstName= 'Subhiksha'
            lastName='S'
            Age= 21
            Company='DigiKas'
            Degree= 'B.Com AF'

           @track QASlot= {
                QASlot1: 'Trialhead',
                QASlot2: 'Linkedin'
            }
        
    
    
    


    handleChange(event) {
        this.firstName = event.target.value


    }
    get name() {
        return this.firstName + ' ' + this.lastName
    }

    handleChangeSlot(event) {
        this.QASlot.QASlot1 = event.target.value
    }

}