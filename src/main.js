import {createApp} from 'vue'
import App from './App.vue'
import router from './router/router.js'
import {store} from './store/store'

import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'


//import locale_en from 'element-ui/lib/locale/lang/en.js'
import locale_en from 'element-plus/dist/locale/en.mjs'

import '@fortawesome/vue-fontawesome';
/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core'

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import {faEnvelope,faBell,faFile} from '@fortawesome/free-regular-svg-icons'
import {faDocker} from '@fortawesome/free-brands-svg-icons'
import {fas} from '@fortawesome/free-solid-svg-icons'
import eventBus from 'vue3-eventbus'

import moment from "moment";
//import {useI18n} from 'vue-i18n'
//import 'element-ui/lib/theme-chalk/reset.css'
import {i18n} from  './i18n-setup'
//import ElementLocale from 'element-plus/lib/locale'
import vueNumeralFilterInstaller from 'vue-numeral-filter';
import draggable from "vuedraggable";
import InfiniteLoading from 'infinite-loading-vue3';


console.log("===============");
console.log("Starting");
console.log("===============");

const app= createApp(App)

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
app.component('v-icon', FontAwesomeIcon)
app.component("draggable", draggable);

app.config.compilerOptions.isCustomElement = (tag) => {
  return tag.startsWith('ChangePasswor') // (return true)
}

app.config.productionTip = false
//app.prototype.$globalbus = new Vue();
//app.prototype.$localbus = new Vue();

app.config.globalProperties.$filters = {
  formatDate(value) {
    if (value) {
      return moment(String(value)).format('DD/MM/YYYY HH:mm')
    } 
  },
  formatTS(value) {
    if (value) {
      if(value < 10000000000)
        value *= 1000 

      return moment(value).format('DD/MM/YYYY HH:mm')
    }
  },
  formatTS2(value) {
    if (value) {
      if(value < 10000000000)
        value *= 1000 
  
      return moment.utc(value).local().format('DD/MM HH:mm:ss')
    }
  },
  capitalize(value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  },
  prettyBytes(num) {
    // jacked from: https://github.com/sindresorhus/pretty-bytes
    if (typeof num !== 'number' || isNaN(num)) {
      throw new TypeError('Expected a number');
    }
  
    var exponent;
    var unit;
    var neg = num < 0;
    var units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  
    if (neg) {
      num = -num;
    }
  
    if (num < 1) {
      return (neg ? '-' : '') + num + ' bytes';
    }
  
    exponent = Math.min(Math.floor(Math.log(num) / Math.log(1000)), units.length - 1);
    num = (num / Math.pow(1000, exponent)).toFixed(0) * 1;
    unit = units[exponent];
  
    return (neg ? '-' : '') + num + ' ' + unit;
  }
}

function getUrlVars() {
  var vars = {};
  window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
      vars[key] = value;
  });
  return vars;
}

var vars=getUrlVars();
if (vars["api"]!=undefined)
{  
  store.state.apiurl=vars["api"].split('#')[0];
}
//ElementLocale.i18n((key, value) => i18n.t(key, value))
library.add(fas,faDocker,faEnvelope,faBell,faFile)


app.component('font-awesome-icon', FontAwesomeIcon)

app.use(router,store)
app.use(i18n)
app.use(ElementPlus, {locale:locale_en})
app.use(store);
//Vue.use(VueI18n) 
//app.use(vueNumeralFilterInstaller);
app.use(InfiniteLoading, { /* options */ });
app.use(eventBus)

app.mount('#app')
