import { mapGetters, mapMutations } from 'vuex';

export default {
  computed: {
    ...mapGetters({
      connected: 'dashboard/connected',
      dna: 'dashboard/dna',
      whales: 'dashboard/whales'
    })
  },

  methods: {
    ...mapMutations({
      addDna: 'dashboard/addDna'
    })
  }
}