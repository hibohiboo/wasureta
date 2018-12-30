import Vuex from 'vuex';

const store = {
  state: {
    items: [],
  },
};

export default () => new Vuex.Store(store);