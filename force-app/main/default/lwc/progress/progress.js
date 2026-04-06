import { LightningElement } from 'lwc';
export default class Progress extends LightningElement {

    handleStart()
    {
        this.refs.child.start()

    }

    handleStop()
    {
        this.refs.child.stop()

    }

    handleReset()
    {
        this.refs.child.reset()

    }

    handleStartTime()
    {

        this.refs.timer.startTime()
        
    }
    handleStopTime()
    {
        this.refs.timer.stopTime()
    }
    handleResetTime()
    {
        this.refs.timer.resetTime()
        
    }






}