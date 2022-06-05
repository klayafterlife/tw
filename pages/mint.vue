<template>
  <div class="container">
    <h1 class="mb-5 mt-5 pb-4">Mint</h1>

    <div class="mb-4">
      작은 고래를 포획하기 위해서는 5 KLU가 필요합니다.<br />
      배경 등 배 눈 색상을 선택하거나 랜덤 조합이 가능합니다.
    </div>

    <div class="mb-4">
      선택하신 색상 조합이 이미 존재할 경우 포획할 수 없습니다.<br />
      같은 색 조합의 고래는 오직 하나만 존재합니다.
    </div>

    <div class="mb-5">
      고래는 천 마리만 존재하며, 6월 말까지만 포획이 가능합니다.
    </div>

    <ConnectWallet v-if="!isKluApproval" />
    <div v-else class="m-5">
      <div class="mb-4">포획된 고래: {{ whaleCnt }}/1000</div>
      
      <whale-preview
        :back.sync="back"
        :eye.sync="eye"
        :body.sync="body"
        :belly.sync="belly"
        btn-text="포획"
        @confirm="mint"
      />
    </div>
  </div>
</template>

<script>
import dashboard from '@/mixins/dashboard.js'
import ConnectWallet from '@/components/ConnectWallet.vue';
import WhalePreview from '@/components/WhalePreview.vue';
import { ABI, ADDR } from '@/plugin/seaKlu.js';

export default {
  mixins: [ dashboard ],

  components: {
    ConnectWallet,
    WhalePreview
  },

  data() {
    return {
      back: '#00CCFF',
      body: '#000000',
      belly: '#FFFFFF',
      eye: '#FFFFFF'
    }
  },

  methods: {
    async mint() {
      if(!this.kluCheck(5)) {
        return;
      }

      if(this.dna.indexOf(this.back+this.eye+this.body+this.belly) > -1) {
        alert('존재하는 색상 조합입니다. 색상을 바꿔주세요.');
        return
      }
      if(this.whaleCnt >= 1000) {
        alert('바다에 남은 고래가 없습니다...');
        return
      }

      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.Mint(
          this.back,
          this.eye,
          this.body,
          this.belly
        ).send({
          from : klaytn.selectedAddress,
          gas: 1500000
        })
        .then(() => {
          alert('작은 고래를 얻었습니다!');
          
          myContract.methods.Dashboard().call().then(res => {
            if(res) {
              this.connect(res);
              this.whale = this.whales[this.index];
            }
          });
        }).catch(() => {
          alert('다시 시도해주세요')
        })
      }, 500);
    }
  },
}
</script>