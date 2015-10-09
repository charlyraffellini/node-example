'use strict';

import React from 'react';
import { connect } from 'react-redux';

class App extends React.Component {
  render() {
    return <div className="node-example">
      <h1>Node example seed</h1>
    </div>;
  }
}

function select(state) {
  return state;
}

export default connect(select)(App);
