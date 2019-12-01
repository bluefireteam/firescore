const initialState = { gameList: null }

const reducer = (state = initialState, action) => {
    switch(action.type) {
        case "LOAD_GAMES": {
            return {
                ...state,
                gameList: action.payload.gameList
            }
        }
        default:
            return state
    }
}

export default reducer;