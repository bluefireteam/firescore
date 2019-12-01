import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux'
import ScoreList from './screens/containers/ScoreList';
import * as serviceWorker from './serviceWorker';

import store from './store'

import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Login from './screens/containers/Login';
import './index.css';

ReactDOM.render(
  <Provider store={store}>
    <Router>
      <Switch>
        <Route path="/scorelist">
          <ScoreList />
        </Route>
        <Route path="/">
          <Login />
        </Route>
      </Switch>
    </Router>
  </Provider>
  , document.getElementById('root'));

serviceWorker.unregister();
