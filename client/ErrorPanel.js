import React from 'react';

export default class ErrorPanel extends React.Component{
    render() {
      return <div>
            { this.props.show &&
              <div>
                <input type="submit" value="Hide Error" onClick={this.props.hide} />
                <div role="alert" className="alert alert-danger">
                    {this.props.text}
                </div>
              </div>
            }
          </div>;
    }
};
