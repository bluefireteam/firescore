const initialState = { scoreBoard: null }

const reducer = (state = initialState, action) => {
    switch(action.type) {
        case "LOAD_SCOREBOARD": {
            return {
                ...state,
                scoreBoardList: action.payload.scoreBoardList,
                loading: false
            }
        }
        default:
            return state
    }
}

export default reducer;