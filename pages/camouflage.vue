<template>
  <div class="container">
    <h1 class="mb-5 mt-5 pb-3">Camouflage</h1>

    <div class="mb-4">
      천적으로부터 살아남기 위해서는 비법이 필요합니다.<br />
      작은 고래는 주의 깊게 보지 않으면 알아채기 어려운 색을 띠거나 위협적인 색으로 무장할 수 있습니다.
    </div>

    <div class="mb-4">
      한 번 사용된 색 조합은 다시 사용할 수 없습니다. 영원히.
    </div>

    <div class="mb-5">
      초기 홀더 혜택 및 예쁜 고래 콘테스트 참여 독려를 위해 한시적으로 보호색 변경 기능이 추가 비용 없이 제공됩니다.
    </div>

    <ConnectWallet v-if="!connected" />
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

        <div v-if="whale" class="row">
          <div class="col preview" :style="{ 'background': back }">
            <img :src="bodyImg" width="100%" height="100%" style="fill: red;">
            <img :src="bellyImg" width="100%" height="100%">
            <img :src="eyeImg" width="100%" height="100%">
          </div>

          <div class="col color-box">
            <div>
              <input type="color" name="backgound" v-model="back">
              <label for="backgound">배경</label>
            </div>
            <div>
              <input type="color" name="eye" v-model="eye">
              <label for="eye">눈</label>
            </div>
            <div>
              <input type="color" name="body" v-model="body">
              <label for="body">몸통</label>
            </div>
            <div>
              <input type="color" name="belly" v-model="belly">
              <label for="belly">배</label>
            </div>
          </div>
        </div>

        <div v-if="whale" class="mt-5">
          <a class="link" @click="colorChange">보호색 적용</a>
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
      whale: null,
      back: '',
      body: '',
      belly: '',
      eye: '',
      idx: 0
    }
  },

  computed: {
    bodyImg() {
      return 'data:image/svg+xml;base64,' + btoa(`<svg width="800" height="800" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges"><path fill="${this.body}" d="M200 250h150v50H200zM150 300h250v50H150zM550 300h50v50h-50zM650 300h50v50h-50zM100 350h350v50H100zM600 350h50v100h-50zM200 400h300v50H200zM550 400h50v50h-50zM250 450h400v50H250zM300 500h300v50H300zM350 550h50v100h-50zM400 550h50v150h-50z"/></svg>`);
    },

    eyeImg() {
      return 'data:image/svg+xml;base64,' + btoa(`<svg version="1.1" width="800" height="800" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges"><rect x="250" y="350" width="50" height="50" fill="${this.eye}" /></svg>`);
    },

    bellyImg() {
      return 'data:image/svg+xml;base64,' + btoa(`<svg width="800" height="800" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges"><path fill="${this.belly}" d="M100 400h100v50H100zM150 450h100v50H150zM200 500h100v50H200zM250 550h100v50H250zM450 550h100v50H450z"/></svg>`);
    }
  },

  methods: {
    findWhaleId(w) {
      return w.name.split(' ')[2];
    },

    selectWhale(w, i) {
      this.idx = i;
      this.whale = w;
      this.back = w.attributes[0].value;
      this.eye = w.attributes[2].value;
      this.body = w.attributes[4].value;
      this.belly = w.attributes[5].value;
    },

    async colorChange() {
      if(this.dna.indexOf(this.back+this.eye+this.body+this.belly) > -1) {
        alert('존재하는 색상 조합입니다. 색상을 바꿔주세요.');
        return
      }

      const id = this.whale.name.split('#')[1];

      await klaytn.enable();
      
      setTimeout(() => {
        const myContract = new caver.klay.Contract(ABI, ADDR);

        myContract.methods.change(
          id,
          this.back,
          this.eye,
          this.body,
          this.belly
        ).send({
          from : klaytn.selectedAddress,
          gas: 1000000
        })
        .on('error', err => {
          if(!`${err}`.includes('User denied transaction signature')) {
            alert('에러가 발생했습니다');
            console.log(err);
          };
        })
        .on('receipt', () => {
          alert('보호색이 변경되었습니다!');
          this.addDna(this.back+this.eye+this.body+this.belly);
          this.changeColor([this.idx, this.back, this.eye, this.body, this.belly]);
        });
      }, 500);
    },

    ...mapMutations({
      changeColor: 'dashboard/changeColor'
    })
  }
}
</script>

<style scoped>
.my-whale {
  border: 2px solid;
  border-radius: 10px;
  padding: 16px;
}

label {
  width: 60px;
}

.color-box {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  align-items: flex-start;
}

.color-box div {
  margin-left: 10px;
  margin-bottom: 0;
}

.preview {
  padding-top: 50%;
}

.preview img {
  position: absolute;
  top: 0;
  left: 0;
}
</style>