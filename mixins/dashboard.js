import { mapGetters, mapMutations } from 'vuex';

export default {
  computed: {
    ...mapGetters({
      isKluApproval: 'dashboard/isKluApproval',
      dna: 'dashboard/dna',
      whales: 'dashboard/whales',
      whaleCnt: 'dashboard/whaleCnt'
    })
  },

  methods: {
    ...mapMutations({
      addDna: 'dashboard/addDna',
      addWhale: 'dashboard/addWhale'
    })
  }
}