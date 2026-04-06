import { LightningElement,api } from 'lwc';
export default class ChildProgress extends LightningElement {

    progress =0
    intervalId

@api start()
{
    this.intervalId= setInterval(()=>{

        this.progress += 1
    },100)


}

@api stop()
{
    clearInterval(this.intervalId)
}

@api reset()
{
   this. progress = 0
}

}