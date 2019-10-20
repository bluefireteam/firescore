import React from "react"
import "./index.css"
import Label from "../Label"

const component = ({ scores, loading }) => {
    return (
        <div>
            {loading ? <Label>carregando</Label> : null}
            {scores.length == 0 ? <Label>vazio</Label> : 
            <table>
                <tr>
                    <th><Label>Player Id</Label></th>
                    <th><Label>Score</Label></th>
                    <th><Label>Metadata</Label></th>
                </tr>
                {scores.map((score) =>
                    <tr key={`score-roll-${score.playerId}`}>
                        <td><Label>{score.playerId}</Label></td>
                        <td><Label>{score.score}</Label></td>
                        <td><Label>{score.metadata}</Label></td>
                    </tr>
                )}
            </table>}
        </div>)
}

export default component