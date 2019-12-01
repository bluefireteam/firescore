import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import score from "./reducers/score"
import session from "./reducers/session"
import games from "./reducers/games"

export default createStore(combineReducers({ score, session, games }), applyMiddleware(thunk));