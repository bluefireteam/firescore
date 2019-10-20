import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import SearchForm from './containers/SearchForm';
import ScoreList from './containers/ScoreList';
import * as serviceWorker from './serviceWorker';

import { Provider } from 'react-redux'
import store from './store'

ReactDOM.render(
  <Provider store={store}>
    <SearchForm />
    <ScoreList />
  </Provider>
  , document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
