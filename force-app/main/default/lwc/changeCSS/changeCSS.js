import  { LightningElement } from 'lwc';

export default class ChangeCSS extends LightningElement {

    style;
    styles;
    
handleChange(event){
    this.style = event.target.value;
}
handleClick(){
    this.styles = this.style;
}


}