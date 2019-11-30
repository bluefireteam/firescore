import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import ScoreList from './screens/containers/ScoreList';
import * as serviceWorker from './serviceWorker';

import { Provider } from 'react-redux'
import store from './store'

ReactDOM.render(
  <Provider store={store}>
    <ScoreList />
  </Provider>
  , document.getElementById('root'));

serviceWorker.unregister();
