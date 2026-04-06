import { LightningElement } from 'lwc';

export default class LoggingBox extends LightningElement {

    showMembers = false;
    showNew = false;

    CrtUsername = 'admin@salesforce.com'
    CrtPassword = 'admin@123'

    username;
    password;

    Login = false;
    Msg = '';

   
    name = ''
    email = ''
   

    handleMemberChange(event) {
        this.showMembers = event.target.checked;
        this.showNew = false;
        this.template.querySelector('.NewCheck').checked = false;
    }

    handleNewChange(event) {
        this.showNew = event.target.checked;
        this.showMembers = false;
        this.template.querySelector('.ExistCheck').checked = false;
    }

    handleUsername(event) {
        this.username = event.target.value;
    }

    handlePass(event) {
        this.password = event.target.value;
    }

    LogCheck() {

        if (this.username === this.CrtUsername && this.password === this.CrtPassword) {


            this.Login = true;
            this.Msg = 'Logged in Successfully'

        }
        else {
            this.Login = true;
            this.Msg = 'Invalid Username or Password'
        }

    }

    handleName(event) {
        this.name = event.target.value;
    }

    handleEmail(event) {
        this.email = event.target.value;
    }

    RegCheck() {
        if (this.name != '' && this.email != '') {
            this.Login = true
            this.Msg = 'Registered Successfully'
        }

        else {
            this.Login = true
            this.Msg = 'Please Enter Name and Email'
        }

    }



}