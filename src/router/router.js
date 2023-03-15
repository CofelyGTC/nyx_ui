import { createRouter,createWebHashHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Main from '../views/Main.vue'


import GenericComponent from '../components/GenericComponent.vue'
// import User from '../components/User.vue'
// import Config from '../components/Config.vue'
// import Loading from "@/components/Loading";


//Vue.use(createRouter);


export default new createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/main',
      name: 'Main',
      component: Main,
      children: [
        // {
        //   path: ':category/:subcategory',
        //   name: 'GenericComponent',
        //   component: GenericComponent          
        // },
        {
          path: ':recid',
          name: 'GenericComponent',
          component: GenericComponent          
        },
      ]
    }
  ]
})
