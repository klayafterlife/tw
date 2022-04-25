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
      보호색 변경에는 5KLAY가 소모됩니다.<br />
      모금된 금액은 추후 작은 고래의 생태계 조성에 사용됩니다.
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

        <whale-preview 
          v-if="whale"
          :back.sync="back"
          :eye.sync="eye"
          :body.sync="body"
          :belly.sync="belly"
          btn-text="보호색 적용"
          @confirm="colorChange"
        />
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
import WhalePreview from '@/components/WhalePreview.vue';
import { ABI, ADDR } from '@/plugin/util.js';

export default {
  mixins: [ dashboard ],

  components: {
    ConnectWallet,
    WhalePreview
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

  methods: {
    findWhaleId(w) {
      return w.name.split(' ')[2];
    },

    selectWhale(w, i) {
      this.idx = i;
      this.whale = w;
      this.back = w.attributes[0].value.toUpperCase();
      this.eye = w.attributes[2].value.toUpperCase();
      this.body = w.attributes[4].value.toUpperCase();
      this.belly = w.attributes[5].value.toUpperCase();
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
          value: caver.utils.toPeb('5', 'KLAY'),
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

          try {
            axios.get(`https://api.klu.bs/v2/pfp/0x2089CFC532195E9568608fD0E8aD7Ab5e4cfDc91/${id}/metadata/cache`);
          } catch {
            console.log('metadata update fail');
          }
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