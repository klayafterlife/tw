<template>
  <div class="container">
    <h1 class="mb-5 mt-5 pb-4">Adventure</h1>

    <div class="mb-4">
      바다에는 아주 많은 보물들이 숨어 있습니다.<br />
      5 KLU의 비용을 지불하면 넓은 바다를 탐험하고 몸을 치장할 수 있는 장식을 얻을 수 있습니다.
    </div>

    <div class="mb-4">
      장식은 머리 장식 / 꼬리 장식 / 입 장식 / 특별 장식 네 가지 부위이며, 계속해서 추가됩니다.<br />
    </div>

    <div class="mb-5">
      모든 장식은 랜덤하게 등장하며, 같은 부위의 장식이 나올 경우 기존 장식은 사라집니다.
    </div>

    <ConnectWallet v-if="!isKluApproval" />
    <div v-else class="mb-4 mt-5">
      <div v-if="whales.length > 0" class="m-5">
        <div class="row my-whale mb-5">
          <div
            v-for="w, i in whales"
            :key="i"
            class="col-3 link"
            @click="selectWhale(w, i)"
          >
            {{ findWhaleId(w) }}
          </div>
        </div>

        <div v-if="whale">
          <img class="mb-5" :src="whale.image" alt="whale">

          <a class="link" @click="hunting">탐험하기</a>
        </div>

      </div>

      <div v-else>
        작은 고래가 다른 지갑에서만 헤엄치고 있습니다.
      </div>
    </div>
  </div>
</template>

<script>
import { mapMutations } from 'vuex';
import dashboard from '@/mixins/dashboard.js';
import ConnectWallet from '@/components/ConnectWallet.vue';
import { ABI, ADDR } from '@/plugin/seaKlu.js';

export default {
  mixins: [ dashboard ],

  components: {
    ConnectWallet
  },

  data() {
    return {
      whale: null,
      id: 0,
      index: 0
    }
  },

  methods: {
    findWhaleId(w) {
      return w.name.split(' ')[2];
    },

    selectWhale(w, i) {
      this.whale = w;
      this.index = i;
      this.id = w.name.split('#')[1];;
    },

    async hunting() {
      if(!this.kluCheck(5)) {
        return;
      }

      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.HuntingItem(this.id)
        .send({
          from : klaytn.selectedAddress,
          gas: 1000000
        }).then(({ events }) => {
          if(events.hunting) {
            let cate;
            switch(events.hunting.returnValues[0]) {
              case 'head':
                cate = '머리 장식'
                break;
              case 'mouth':
                cate = '입 장식'
                break;
              case 'tail':
                cate = '꼬리 장식'
                break;
              case 'item':
                cate = '특별 장식'
                break;
            }

            alert(`${cate} 변경: ${events.hunting.returnValues[1]}`);

            myContract.methods.Dashboard().call().then(res => {
              if(res) {
                this.connect(res);
                this.whale = this.whales[this.index];
              }
            });
          }

        }).catch(() => {
          alert('다시 시도해주세요')
        });
      }, 500);
    }
  },
}
</script>

<style scoped>
.my-whale {
  border: 2px solid;
  border-radius: 10px;
  padding: 16px;
}

img {
  width: 100%;
}
</style>