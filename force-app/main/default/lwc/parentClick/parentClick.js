import { LightningElement } from 'lwc';

export default class ParentClick extends LightningElement {

    showChild

    name=[];

    handleParentClick()
    {
        this.showChild=true

    }

    handleChildClick(event)
    {
        this.showChild = false

        if(event.detail.length === 0){
        this.name = ['No players chosen'];
    }
    else{
        this.name = [...event.detail];
    }

       
    }



}