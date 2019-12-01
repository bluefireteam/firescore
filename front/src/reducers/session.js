const initialState = { loading: false, token: null, account: null }

const reducer = (state = initialState, action) => {
    switch(action.type) {
        case "LOGIN_STARTED": {
            return {
                ...state,
                loading: true
            }
        }
        case "LOGIN_DONE": {
            return {
                ...state,
                account: action.payload.account,
                token: action.payload.token,
                loading: false
            }
        }
        default:
            return state
    }
}

export default reducer;