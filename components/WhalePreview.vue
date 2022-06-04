<template>
  <div>
    <div class="row">
      <div class="col preview" :style="{ 'background': back }">
        <img :src="bodyImg" width="100%" height="100%" style="fill: red;">
        <img :src="bellyImg" width="100%" height="100%">
        <img :src="eyeImg" width="100%" height="100%">
      </div>

      <div class="col color-box">
        <div>
          <input type="color" name="backgound" v-model="backModel">
          <label for="backgound">배경</label>
        </div>
        <div>
          <input type="color" name="eye" v-model="eyeModel">
          <label for="eye">눈</label>
        </div>
        <div>
          <input type="color" name="body" v-model="bodyModel">
          <label for="body">몸통</label>
        </div>
        <div>
          <input type="color" name="belly" v-model="bellyModel">
          <label for="belly">배</label>
        </div>
      </div>
    </div>

    <div class="mt-5 row">
      <a class="col link" @click="randomBtn">랜덤 색상</a>
      <a class="col link" @click="$emit('confirm')">{{ btnText }}</a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    back: {
      type: String,
      required: true
    },
    eye: {
      type: String,
      required: true
    },
    body: {
      type: String,
      required: true
    },
    belly: {
      type: String,
      required: true
    },
    btnText: {
      type: String,
      required: true
    }
  },

  computed: {
    backModel: {
      get () { return this.back },
      set (value) { this.$emit('update:back', value.toUpperCase()) },
    },

    eyeModel: {
      get () { return this.eye },
      set (value) { this.$emit('update:eye', value.toUpperCase()) },
    },

    bodyModel: {
      get () { return this.body },
      set (value) { this.$emit('update:body', value.toUpperCase()) },
    },

    bellyModel: {
      get () { return this.belly },
      set (value) { this.$emit('update:belly', value.toUpperCase()) },
    },

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

  mounted() {
    if(this.btnText == '포획') {
      this.randomBtn();
    }
  },

  methods: {
    randomColor() {
      return "#" + Math.round(Math.random() * 0xffffff).toString(16).toUpperCase();
    },

    randomBtn() {
      this.$emit('update:back', this.randomColor());
      this.$emit('update:eye', this.randomColor());
      this.$emit('update:body', this.randomColor());
      this.$emit('update:belly', this.randomColor());
    }
  }
}
</script>

<style scoped>
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