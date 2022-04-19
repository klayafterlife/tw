<template>
  <a class="link" @click="walletConnect">지갑 연결</a>
</template>

<script>
import { mapMutations } from 'vuex';
import { ABI, ADDR } from '@/plugin/manage.js';

export default {
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

      await klaytn.enable()
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.getDna().call().then(res => {
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

        myContract.methods.getWhales().call().then(res => {
          this.setWhales(res);
        });
      }, 500);
    },

    ...mapMutations({
      connect: 'dashboard/connect',
      setWhales: 'dashboard/setWhales'
    })
  }
}
</script>