import { LightningElement,api } from 'lwc';
export default class ChildCorousel extends LightningElement {

    _cValue

    @api
    get child()
    {
        return   this._cValue

    }

    set child(value)
    {
       this. _cValue =value

    }

}