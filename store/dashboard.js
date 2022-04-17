export const state = () => ({
  connected: false,
  dna: []
});

export const getters = {
  connected(state) {
    return state.connected;
  },

  dna(state) {
    return state.dna;
  }
}

export const mutations = {
  connect(state, dna) {
    state.connected = true;
    state.dna = dna;
  },

  addDna(state, dna) {
    state.dna.push(dna);
  }
}