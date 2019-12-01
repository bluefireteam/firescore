import React, { useEffect } from "react"

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
                            <td>{game.name}</td>
                        </tr>
                    )}
                </tbody>
            </table>
        </div>
    )
}

export default GameList