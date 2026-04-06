import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {

    isShopping = false;
    isReading = false;
    

    handleShoppingChange(event) {
        this.isShopping = event.target.checked
        this.isReading = false;
        this.template.querySelector('.ReadCheck').checked = false;
        
    }

    handleReadingChange(event)
    {
        this.isReading = event.target.checked
        this.isShopping = false;
        this.template.querySelector('.ShopCheck').checked = false;
        
    }



}