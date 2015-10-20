import React from 'react';
import { createOrdineAsync } from './actions';

export default class Ordine extends React.Component {
  constructor(props) {
    super(props);
    //this.handleChange = this.handleChange.bind(this);
    this.handleCreate = this.handleCreate.bind(this);
  }

  handleCreate(){
    const { userid, ordiniType, validateAndDo, dispatch } = this.props;
    const quantityNode = React.findDOMNode(this.refs.quantity);
    const priceNode = React.findDOMNode(this.refs.price);
    const qty = quantityNode.value.trim();
    const price = priceNode.value.trim();

    if (qty && price) {
      let ordine = {userid, price, qty, ordiniType};

      validateAndDo(ordine, (ordine) =>{
        dispatch(createOrdineAsync(ordine));
        quantityNode.value = priceNode.value = 0;
        priceNode.value = priceNode.value = 0;
      });
    }
  };

  render() {
    let { title } = this.props;

    return <div className="col-xs-6">
            <span className="row">
              <h2 className="col-md-3">{title}</h2>
              <p><input type="number" ref="quantity" placeholder="Quantita" className="col-md-3"/></p>
              <p><input type="number" ref="price" placeholder="Price" className="col-md-3"/></p>
              <a href="#" className="btn btn-default btn-sm col-md-3"
                 onClick={this.handleCreate}>
                AddOrdine
              </a>
            </span>
          </div>
  };
}
