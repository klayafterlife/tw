export default {
  ssr: false,

  head: {
    title: 'Tiny Whales',
    htmlAttrs: {
      lang: 'ko'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.png' }
    ]
  },

  css: [],

  plugins: [],

  components: true,

  buildModules: [],

  modules: [
    'bootstrap-vue/nuxt',
  ],

  build: {
    extend (config) {
      config.node= {
         fs: 'empty'
       }
   }
  }
}
