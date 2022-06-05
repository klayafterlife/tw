import { mapGetters, mapMutations } from 'vuex';

export default {
  computed: {
    ...mapGetters({
      isKluApproval: 'dashboard/isKluApproval',
      dna: 'dashboard/dna',
      whales: 'dashboard/whales',
      whaleCnt: 'dashboard/whaleCnt',
      kluBalance: 'dashboard/kluBalance'
    })
  },

  methods: {
    kluCheck(value) {
      if(value > this.kluBalance) {
        alert('KLU가 부족합니다');

        return false;
      }

      return true;
    },

    ...mapMutations({
      addDna: 'dashboard/addDna',
      addWhale: 'dashboard/addWhale',
      connect: 'dashboard/connect'
    })
  }
}