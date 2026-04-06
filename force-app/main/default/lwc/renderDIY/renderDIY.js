import { LightningElement } from 'lwc';
import calculator from './calculator.html'
import sciCalculator from './sciCalculator.html'
import renderDemo from'./renderDIY.html'

export default class RenderDIY extends LightningElement {

    value;

    displayValue=''

    

    render()
    {
      return this.value === 'Calculator' ? calculator : this.value === 'Scientific Calculator' ? sciCalculator : renderDemo

    }

    handleClick(event)
    {
        this.value = event.target.label

        console.log(this.value)
    }

    handleNumber(event)
    {
       
        const val= event.target.dataset.value

         this.displayValue+=val
    }

    handleOperator(event)
    {
       
        const val= event.target.dataset.value

         this.displayValue+=val
    }

    handleClear()
    {
        this.displayValue=''
    }
    handleBackSpace()
    {
        this.displayValue = this.displayValue.slice(0,-1)
    }
    result()
    {
        try{
            this.displayValue=eval(this.displayValue)
        }
        catch(error){

            this.displayValue='Error!'

        }
    }


}