import { LightningElement } from 'lwc';
import sachinImg from '@salesforce/resourceUrl/sachin';
import viratImg from '@salesforce/resourceUrl/virat';
import dhoniImg from '@salesforce/resourceUrl/dhoni';
export default class ChildClick extends LightningElement {

    players =[
        
        {name : 'Sachin',
        img : sachinImg},
        {name : 'Dhoni',
        img : dhoniImg},
        {name : 'Virat',
        img : viratImg}
        ]

     //   playerName
        selectedPlayers = [];

        handleCheck(event)
        {
             const playerName = event.target.dataset.name
              if(event.target.checked){
        this.selectedPlayers.push(playerName);
    } 
    else{
        this.selectedPlayers = this.selectedPlayers.filter(name => name !== playerName);
    }
             
        }

handleClose()
{
   
     const myEvent = new CustomEvent('close',{detail:[...this.selectedPlayers]})

       this.dispatchEvent(myEvent)

}
       


}