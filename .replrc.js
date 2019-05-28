module.exports = {
  context: {
    _: require('lodash'),
    getProp: require('@f/get-prop'),
    setProp: require('@f/set-prop'),
    moment: require('moment'),
    numeral: require('numeral'),
    api: require('@therebel/fetchapi'),
    camel: require('camel-case'),
    ksuid: require('@therebel/ksuid'),
    popmotion: require('popmotion')
  },
  enableAwait: true
};
