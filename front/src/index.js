import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import ScoreList from './screens/containers/ScoreList';
import * as serviceWorker from './serviceWorker';

import { Provider } from 'react-redux'
import store from './store'

import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link
} from "react-router-dom";


ReactDOM.render(
  <Provider store={store}>
    <Router>
      <Route path="/scorelist">
        <ScoreList />
      </Route>
    </Router>
  </Provider>
  , document.getElementById('root'));

serviceWorker.unregister();
