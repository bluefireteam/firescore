import { createStore, combineReducers } from "redux";
import score from "./reducers/score"
import session from "./reducers/session"

export default createStore(combineReducers({ score, session }));