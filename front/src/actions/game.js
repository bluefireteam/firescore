export const fetchGames = () => (dispatch, getState) => {
    const headers = new Headers();
    headers.set('Authorization', 'Basic ' + getState().session.token);

    fetch(`https://api.score.fireslime.xyz/admin/games`, { headers })
    .then(resp => {
        return resp.json()
    })
    .then(gameList => {
        dispatch({type: "LOAD_GAMES", payload: { gameList }})
    })
    .catch(error => {
        console.log("Fail to fetch games", error)
    })
}
