import React, { Component } from "react"
import "./index.css"
import Title from "../Title"
import Label from "../Label"
import Button from "../Button"

class SearchForm extends Component {

    constructor(props) {
        super(props)
        this.state = { uuid: props.uuid }
    }

    handleFetchScores() {
        if (this.state.uuid) {
            const { fetchScores, loading } = this.props
            if (!loading) {
                fetchScores(this.state.uuid)
            }
        }
    }

    render() {
        return (
            <div className="scoreboard-form">
                <Title className="scoreboard-title">Scoreboard</Title>
                <Label>UUID: </Label>
                <input type="text" value={this.state.uuid} onChange={(input) => { this.setState({ uuid: input.target.value})}}></input>
                <br/><br/>
                <Button title="Search" click={() => this.handleFetchScores()}></Button>
            </div>)
    }
}

export default SearchForm