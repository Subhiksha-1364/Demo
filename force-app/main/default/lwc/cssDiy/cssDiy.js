import { LightningElement } from 'lwc';

export default class CssDiy extends LightningElement {


    symbol;
    description;
    style;

    handleChange(event){
        this.symbol = event.target.value;
    }

    handleClick(){
        switch(this.symbol)
        {
            case '{}':
                this.description = 'This is a description for {} symbol . It creates an object in JS';
                this.style ='bgClr' 
                break;
            case '[]':
                this.description = 'This is a description for [] symbol . It creates an array in JS';
                this.style ='bgClr' 
                break;
            case '%':
                this.description = 'This is a description for % symbol . It is a modulus operator in JS';
                this.style ='bgClr' 
                break;
            case '===':
                this.description = 'This is a description for === symbol . It is a strict equality operator in JS';
                this.style ='bgClr' 
                break;
            case '&&':
                this.description = 'This is a description for && symbol . It is a logical AND operator in JS';
                this.style ='bgClr' 
                break;
            case '||':
                this.description = 'This is a description for || symbol . It is a logical OR operator in JS';
                this.style ='bgClr' 
                break;

            default :
                this.description = 'Enter a valid symbol';
                this.style ='bgClr'
            
        }

        this.symbol = '';

    }   
}