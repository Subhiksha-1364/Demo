import { LightningElement } from 'lwc';
export default class Slider extends LightningElement {


    currentVal;

    handleSliderChange(event)
    {
       this.currentVal = event.target.value;

    }



}