import React, { useEffect } from "react"
import { Link } from "react-router-dom"

const GameList = ({ fetchGames, gameList }) => {
    useEffect(() => {
        if (!gameList) {
            fetchGames()
        }
    })

    return (
        <div>
            <table>
                <thead>
                    <tr>
                        <td>Id</td>
                        <td>Game</td>
                    </tr>
                </thead>
                <tbody>
                    {(gameList || []).map(game => 
                        <tr key={`game-roll-${game.id}`}>
                            <td>{game.id}</td>
                            <td><Link to={`/gameboard/${game.id}`}>{game.name}</Link></td>
                        </tr>
                    )}
                </tbody>
            </table>
        </div>
    )
}

export default GameList