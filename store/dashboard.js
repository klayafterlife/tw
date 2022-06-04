export const state = () => ({
  connected: false,
  whaleCnt: 0,
  kluBalance: 0,
  kluApproval: 0,
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
  },

  whaleCnt(state) {
    return state.whaleCnt;
  },

  kluBalance(state) {
    return state.kluBalance;
  },

  isKluApproval(state) {
    return state.kluApproval >= 5;
  }
}

export const mutations = {
  connect(state, data) {
    state.connected = true;
    state.kluBalance = Number(data[0])/10**18;
    state.kluApproval = Number(data[1])/10**18;
    state.whaleCnt = Number(data[2]);

    state.dna = data[3].map(d => d.toUpperCase());

    state.whales = [];
    if(data[4]) {
      data[4].forEach(encodedWhale => {
        state.whales.push(
          JSON.parse(atob(encodedWhale.replace(/^data:\w+\/\w+;base64,/, '')))
        );
      });
    }
  },

  addDna(state, dna) {
    state.dna.push(dna);
  },

  addWhale(state) {
    state.whaleCnt = state.whaleCnt + 1;
  },

  setKluApprove(state, balance) {
    state.kluApproval = balance;
  },

  changeColor(state, [idx, back, eye, body, belly]) {
    const whale = state.whales[idx];

    whale.attributes[0].value = back;
    whale.attributes[2].value = eye;
    whale.attributes[4].value = body;
    whale.attributes[5].value = belly;
  }
}