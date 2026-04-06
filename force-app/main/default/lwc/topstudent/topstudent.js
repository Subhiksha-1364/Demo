import { LightningElement,track} from 'lwc';
export default class Topstudent extends LightningElement {

    name
    score
    team
    addScore
    players=[]

    topPlayer

  @track topPlayerArray=[]

    handleName(event)
    {
        this.name=event.target.value

    }
    handleScore(event)
    {
        this.score=event.target.value
    }
    handleTeam(event)
    {
        this.team=event.target.value
    }

    addMem(event)
    {
        this.addScore=event.target.checked
        if(this.name && this.score && this.team)
        {
           this.players=[...this.players,{

                name:this.name,
                score:Number(this.score),
                team:this.team

            }]
        }

        this.name=''
        this.score=''
        this.team=''
        this.addScore = false
        event.target.checked =false


    }

    handleView()
    {
         let top=this.players[0]

        if(this.players.length===0)
        {
            return
        }
           
            this.players.forEach(player => {

                if(player.score>top.score)
                {
                    top=player
                }
            })
        
        this.topPlayer = top

       this. topPlayerArray = [...this.topPlayerArray,top]




    }




}