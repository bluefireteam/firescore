export const fetchScoreList = (uuid) => (dispatch, getState) => {
    dispatch({type: "LOADING_SCORES"})

    fetch(`https://api.score.fireslime.xyz/scores/${uuid}?sortOrder=DESC`)
    .then(resp => {
        return resp.json()
    })
    .then(scores => {
        dispatch({type: "LOAD_SCORES", payload: { scores }})
    })
    .catch(error => {
        console.log("Fail to fetch scores", error)
    })
}