import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux'
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import store from './store'

import * as serviceWorker from './serviceWorker';

import Login from './screens/containers/Login';
import GameList from './screens/containers/GameList';
import ScoreList from './screens/containers/ScoreList';
import GameScoreBoard from './screens/containers/GameScoreBoard';

import './index.css';

ReactDOM.render(
  <Provider store={store}>
    <Router>
      <Switch>
        <Route path="/scorelist/:uuid">
          <ScoreList />
        </Route>
        <Route path="/gamelist">
          <GameList />
        </Route>
        <Route path="/gameboard/:gameId">
          <GameScoreBoard />
        </Route>
        <Route path="/">
          <Login />
        </Route>
      </Switch>
    </Router>
  </Provider>
  , document.getElementById('root'));

serviceWorker.unregister();
