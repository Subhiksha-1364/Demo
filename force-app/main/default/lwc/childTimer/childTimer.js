import { LightningElement, api } from 'lwc';
export default class ChildTimer extends LightningElement {

    time = '00:00'
    totalSec=0
    intervalId

    @api startTime() {

        if(this.intervalId)
        {
             clearInterval(this.intervalId)

        }

        this.intervalId = setInterval(()=>{

            this.totalSec ++

            const min = Math.floor( this.totalSec /60)
            const sec = this.totalSec %60 

            this.time = this.format(min) +':'+this.format(sec)
        },1000)

    }
    @api stopTime() {

        clearInterval(this.intervalId)

    }

    @api resetTime() {

         clearInterval(this.intervalId)
         this.totalSec =0

        this.time='00:00' 

    }

    format(value) {
        return value < 10 ? '0' + value : value;
    }


}