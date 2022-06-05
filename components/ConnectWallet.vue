<template>
  <a v-if="!connected" class="link" @click="walletConnect">지갑 연결</a>
  <a v-else class="link" @click="kluApprove">KLU 승인</a>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';
import { ABI, ADDR } from '@/plugin/seaKlu.js';
import { KLU_ABI, KLU_ADDR } from '@/plugin/klu.js';

export default {
  computed: {
    ...mapGetters({
      connected: 'dashboard/connected'
    })
  },

  methods: {
    async walletConnect() {
      const { klaytn } = window;
      if (!klaytn || !klaytn.isKaikas) {
        alert('KAIKAS 확장프로그램 설치가 필요합니다');
        return;
      }
      if(klaytn.networkVersion !== 8217) {
        alert('Cypress Main Network로 변경해주세요')
        return;
      }

      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.Dashboard().call().then(res => {
          if(res) {
            this.connect(res);

            klaytn.on('accountsChanged', () => {
              alert('지갑이 변경되었습니다')
              location.reload();
            });
            
          } else {
            alert('다시 시도해주세요');
          }
        });
      }, 500);
    },

    async kluApprove() {
      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(KLU_ABI, KLU_ADDR);
        const maxNum = caver.utils.toBN("2").pow(caver.utils.toBN("256").sub(caver.utils.toBN("1")));

        myContract.methods.approve(ADDR, maxNum).send({
          from : klaytn.selectedAddress,
          gas: 300000
        }).then(() => {
          this.setKluApprove(Number(maxNum.div(caver.utils.toBN("10").pow(caver.utils.toBN("18")))));
        }).catch(() => {
          alert('다시 시도해주세요')
        });
      }, 500);
    },

    ...mapMutations({
      connect: 'dashboard/connect',
      setKluApprove: 'dashboard/setKluApprove'
    })
  }
}
</script>