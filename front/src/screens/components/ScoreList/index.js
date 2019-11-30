import React, { useState } from "react"
import Label from "../../../components/Label"
import Title from "../../../components/Title"
import Button from "../../../components/Button"
import "./index.css"

const ScoreList = ({ fetchScores, scores, loading }) => {
    const [uuid, setUuid] = useState();

    const handleFetchScores = () => {
        if (uuid && !loading) {
            fetchScores(uuid)
        }
    }

    return (
        <div>
            <div className="scoreboard-form">
                <Title className="scoreboard-title">Scoreboard</Title>
                <Label>UUID: </Label>
                <input type="text" value={uuid} onChange={(input) => { setUuid(input.target.value) }}></input>
                <br/><br/>
                <Button title="Search" click={() => handleFetchScores()}></Button>
            </div>

            {loading ? <Label>carregando</Label> : null}
            {scores.length === 0 ? <Label>vazio</Label> : 
            <table>
                <thead>
                    <tr>
                        <th><Label>Player Id</Label></th>
                        <th><Label>Score</Label></th>
                        <th><Label>Metadata</Label></th>
                    </tr>
                </thead>
                <tbody>
                    {scores.map((score) =>
                        <tr key={`score-roll-${score.playerId}`}>
                            <td><Label>{score.playerId}</Label></td>
                            <td><Label>{score.score}</Label></td>
                            <td><Label>{score.metadata}</Label></td>
                        </tr>
                    )}
                </tbody>
            </table>}
        </div>)
}

export default ScoreList