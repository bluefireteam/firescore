import React, { useEffect } from "react"
import { Link } from "react-router-dom"

const GameScoreBoard = ({ scoreBoardList, fetchScoreBoard }) => {
    useEffect(() => {
        if (!scoreBoardList) {
            fetchScoreBoard()
        }
    })

    return (
        <div>
            <table>
                <thead>
                    <tr>
                        <td>Id</td>
                        <td>ScoreList</td>
                    </tr>
                </thead>
                <tbody>
                    {(scoreBoardList || []).map(scoreBoard => 
                        <tr key={`scoreBoard-roll-${scoreBoard.id}`}>
                            <td>{scoreBoard.id}</td>
                            <td><Link to={`/scorelist/${scoreBoard.uuid}`}>{scoreBoard.name}</Link></td>
                        </tr>
                    )}
                </tbody>
            </table>
        </div>

    )
}

export default GameScoreBoard