import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import score from "./reducers/score"
import session from "./reducers/session"
import games from "./reducers/games"
import scoreboard from "./reducers/scoreboard"

export default createStore(combineReducers({ score, session, games, scoreboard }), applyMiddleware(thunk));