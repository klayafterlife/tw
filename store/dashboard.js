export const state = () => ({
  connected: false,
  dna: [],
  whales: []
});

export const getters = {
  connected(state) {
    return state.connected;
  },
  dna(state) {
    return state.dna;
  },
  whales(state) {
    return state.whales;
  }
}

export const mutations = {
  connect(state, dna) {
    state.connected = true;
    state.dna = dna;
  },

  addDna(state, dna) {
    state.dna.push(dna);
  },

  setWhales(state, whales) {
    state.whales = [];

    if(whales) {
      whales.forEach(encodedWhale => {
        state.whales.push(
          JSON.parse(atob(encodedWhale.replace(/^data:\w+\/\w+;base64,/, '')))
        );
      });
    }
  },

  changeColor(state, [idx, back, eye, body, belly]) {
    const whale = state.whales[idx];

    whale.attributes[0].value = back;
    whale.attributes[2].value = eye;
    whale.attributes[4].value = body;
    whale.attributes[5].value = belly;
  }
}