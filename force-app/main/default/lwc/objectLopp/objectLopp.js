import { LightningElement, track } from 'lwc';

export default class ObjectLopp extends LightningElement {


    FName;
    LName;
    Ages;
    Deg;
    Comp;
    QA1;
    QA2;

    hasDetail = false;


    @track profile = [
        {
            firstName: 'Subhiksha',
            lastName: 'S',
            Age: 21,
            Company: 'DigiKas',
            Degree: 'B.Com AF',

            QASlot: {
                QASlot1: 'Trialhead',
                QASlot2: 'Linkedin'
            }
        }
    ]

    /*  get name() {
         return this.firstName + ' ' + this.lastName
     } */




    handleFirstName(event) {
        this.FName = event.target.value
    }

    handleLastName(event) {
        this.LName = event.target.value
    }

    handleAge(event) {
        this.Ages = event.target.value
    }

    handleCompany(event) {
        this.Comp = event.target.value
    }

    handleDegree(event) {
        this.Deg = event.target.value
    }

    handleQA1(event) {
        this.QA1 = event.target.value
    }

    handleQA2(event) {
        this.QA2 = event.target.value
    }



    handleAdd() {

        if (!this.FName || !this.LName || !this.Ages || !this.Comp || !this.Deg || !this.QA1 || !this.QA2) {
            alert('Please fill all the fields')
            return
        }
        else{

       

        const newProfile = {
            firstName: this.FName,
            lastName: this.LName,
            Age: this.Ages,
            Company: this.Comp,
            Degree: this.Deg,
            QASlot: {
                QASlot1: this.QA1,
                QASlot2: this.QA2
            }
        }
        this.profile.push(newProfile)

        this.handleClear()
         }


    }




    handleClear() {
        this.FName = ''
        this.LName = ''
        this.Ages = ''
        this.Comp = ''
        this.Deg = ''
        this.QA1 = ''
        this.QA2 = ''
    }

    handleDisplay() {
        this.hasDetail = true
    }

    get NotEmpty() {
        return this.profile.length > 0
    }
}