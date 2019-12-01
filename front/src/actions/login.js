export const login = (username, password) => (dispatch, getState) => {
    dispatch({type: "LOGIN_STARTED"})

    const token = btoa(username + ":" + password);
    
    const headers = new Headers();
    headers.set('Authorization', 'Basic ' + token);

    return fetch(`https://api.score.fireslime.xyz/admin/account`, { headers })
    .then(resp => {
        return resp.json()
    })
    .then(account => {
        dispatch({type: "LOGIN_DONE", payload: { account, token }})
    })
    .catch(error => {
        console.log("Fail to login", error)
    })
}