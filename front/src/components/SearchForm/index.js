import React, { useState } from "react"
import "./index.css"
import Title from "../Title"
import Label from "../Label"
import Button from "../Button"

const SearchForm = ({ fetchScores, loading }) => {
    const [uuid, setUuid] = useState();

    const handleFetchScores = () => {
        if (uuid && !loading) {
            fetchScores(uuid)
        }
    }

    return (
        <div className="scoreboard-form">
            <Title className="scoreboard-title">Scoreboard</Title>
            <Label>UUID: </Label>
            <input type="text" value={uuid} onChange={(input) => { setUuid(input.target.value) }}></input>
            <br/><br/>
            <Button title="Search" click={() => handleFetchScores()}></Button>
        </div>)
}

export default SearchForm