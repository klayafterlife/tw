<template>
  <div class="container">
    <h1 class="mb-5 mt-5">Mint</h1>

    <div class="mb-4">
      작은 고래는 토이프로젝트입니다.<br />
      보호색 및 낚시 기능 추가 외에는 로드맵이 없습니다.<br />
      재미와 수집으로만 접근해주세요.<br />
    </div>

    <div class="mb-4">
      무료일 경우 필요 없음에도 과하게 민팅하는 현상이 있을 수 있어 5 KLAY의 비용을 받습니다.<br />
      배경, 등, 배, 눈의 색상 선택 후 민팅할 수 있습니다.<br />
      선택하신 색상 조합이 이미 존재할 경우 실패합니다.
    </div>

    <ConnectWallet v-if="!connected" />
    <div v-else class="mb-4 mt-5">
      <div class="mb-3">{{ cnt }}/1000</div>
      <div>
        <input type="color" name="backgound" v-model="back">
        <label for="backgound" class="mr-5">배경</label>
        
        <input type="color" name="eye" v-model="eye">
        <label for="eye">눈</label>
      </div>

      <div>
        <input type="color" name="body" v-model="body">
        <label for="body" class="mr-5">몸통</label>
        
        <input type="color" name="belly" v-model="belly">
        <label for="belly">배</label>
      </div>

      <div class="mt-5">
        <a class="link" @click="mint">포획</a>
      </div>
    </div>
  </div>
</template>

<script>
import dashboard from '@/mixins/dashboard.js'
import ConnectWallet from '@/components/ConnectWallet.vue';
import { ABI, ADDR } from '@/plugin/util.js';

export default {
  mixins: [ dashboard ],

  components: {
    ConnectWallet
  },

  data() {
    return {
      back: '#00CCFF',
      body: '#000000',
      belly: '#FFFFFF',
      eye: '#FFFFFF',
      cnt: 0
    }
  },

  watch: {
    connected(val) {
      if(val) {
        this.getCnt();
      }
    }
  },

  mounted() {
    if(this.connected) {
      this.getCnt();
    }
  },

  methods: {
    async mint() {
      if(this.dna.indexOf(this.back+this.eye+this.body+this.belly) > -1) {
        alert('존재하는 색상 조합입니다. 색상을 바꿔주세요.');
        return
      }
      if(this.cnt >= 1000) {
        alert('바다에 남은 고래가 없습니다...');
        return
      }

      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.mint(
          this.back,
          this.eye,
          this.body,
          this.belly
        ).send({
          from : klaytn.selectedAddress,
          value: caver.utils.toPeb('5', 'KLAY'),
          gas: 1500000
        })
        .on('error', err => {
          if(!`${err}`.includes('User denied transaction signature')) {
            alert('에러가 발생했습니다');
            console.log(err);
          };
        })
        .on('receipt', () => {
          alert('작은 고래를 얻었습니다!');
          this.addDna(this.back+this.eye+this.body+this.belly);

          this.cnt += 1;
        });
      }, 500);
    },

    getCnt() {
      const myContract = new caver.klay.Contract(ABI, ADDR);

      myContract.methods.totalSupply().call().then(res => {
        this.cnt = res;
      });
    }
  },
}
</script>