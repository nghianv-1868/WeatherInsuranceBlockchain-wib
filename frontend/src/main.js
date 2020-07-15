import Vue from 'vue';
import App from './App.vue';
import store from './store';
import VModal from 'vue-js-modal';
import BootstrapVue from 'bootstrap-vue';
import VueSwal from 'vue-swal';

import { router } from './router';
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

import ElementUI from 'element-ui';
import './styles.scss';

Vue.use(BootstrapVue);
Vue.use(VModal);
Vue.use(ElementUI);
Vue.use(VueSwal);

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: (h) => h(App)
}).$mount('#app');
