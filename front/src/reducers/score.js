const initialState = { uuid: "", loading: false, scores: null }

const reducer = (state = initialState, action) => {
    switch(action.type) {
        case "LOADING_SCORES": {
            return {
                ...state,
                loading: true
            }
        }
        case "LOAD_SCORES": {
            return {
                ...state,
                scores: action.payload.scores,
                loading: false
            }
        }
        default:
            return state
    }
}

export default reducer;