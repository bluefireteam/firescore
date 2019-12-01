import React, { useEffect } from "react"
import Label from "../../../components/Label"

const ScoreList = ({ fetchScores, scores, loading }) => {
    useEffect(() => {
        if (!scores) {
            fetchScores()
        }
    })

    return (
        <div>
            <table>
                <thead>
                    <tr>
                        <th><Label>Player Id</Label></th>
                        <th><Label>Score</Label></th>
                        <th><Label>Metadata</Label></th>
                    </tr>
                </thead>
                <tbody>
                    {(scores || []).map((score) =>
                        <tr key={`score-roll-${score.playerId}`}>
                            <td><Label>{score.playerId}</Label></td>
                            <td><Label>{score.score}</Label></td>
                            <td><Label>{score.metadata}</Label></td>
                        </tr>
                    )}
                </tbody>
            </table>
        </div>)
}

export default ScoreList