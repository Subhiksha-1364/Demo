import { LightningElement } from 'lwc';

export default class TextBox extends LightningElement {

    chosenStyle;
    text;
    word;

    handleChange(event) {
        this.word= event.target.value


    }

    handleClick() {
        const clean = this.word.toLowerCase();

        const reverse = clean.split('').reverse().join('');
        //const isPalindrome = (word) => word === reverse;

        if(clean === reverse)
        {
            this.chosenStyle = 'BgdClrGrn'
            this.text = 'Palindrome'
            
        }
        else
        {
            this.chosenStyle = 'BgdClrRed'
            this.text = 'Not a Palindrome'
            
        
        }   
        this.word = ''
       
 
    }
}