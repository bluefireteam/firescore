export const fetchScoreboard = (gameId) => (dispatch, getState) => {
    const headers = new Headers();
    headers.set('Authorization', 'Basic ' + getState().session.token);

    return fetch(`https://api.score.fireslime.xyz/admin/games/${gameId}/score_boards`, { headers })
    .then(resp => {
        return resp.json()
    })
    .then(scoreBoardList => {
        dispatch({type: "LOAD_SCOREBOARD", payload: { scoreBoardList }})
    })
    .catch(error => {
        console.log("Fail to load scoreboard", error)
    })
}