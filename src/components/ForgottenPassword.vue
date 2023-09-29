<template>
    <el-form class="pw-reset-form" label-width="0px">
        <el-col :span="24">
          <div v-if="!mailSent">
            <el-form-item label>
              <el-input
                placeholder="Enter email address"
                name="login"
                autocomplete="none"
                v-model="form.login"
                size="medium"
                clearable
              ></el-input>
            </el-form-item>
            <el-button
              class="login-button"
              @click="sendPasswordReset()"
              type="primary"
              size="default"
            >Send password Reset</el-button>
          </div>
          <div v-else>
            <el-form-item label>
              <el-input
                placeholder="Enter Token"
                name="token"
                v-model="form.token"
                size="medium"
              ></el-input>
            </el-form-item>
            <el-button
              class="login-button"
              @click="checkToken()"
              type="primary"
              size="default"
            >Check Token</el-button>
          </div>
          <div class="login_error" v-if="form.error">{{form.error}}</div>
        </el-col>
    </el-form>
</template>
  
  <script>
  import axios from "axios";
  
  export default {
    name: "forgottenPassword",
    data: () => ({
        form:{
            login:"",
            token:"",
            error:""
        },
        mailSent: false
    }),
    props: {
      config: {
        type: Object
      }
    },
    methods: {
      async sendPasswordReset(){
        const url = this.$store.getters.apiurl + "cred/forgottenpassword"
      const query = {
        login: this.form.login,
      };
      const response = await axios.post(url, query)
      if (response.data.error==""){
        this.mailSent=true;
        this.$notify({
              title: "Mail Sent",
              message: "A token was sent to your email account",
              type: "success",
              position: "bottom-right"
            });
      }else{
        this.form.error=response.data.error;
      }
      } 
    },
    created: function() {},
  
    mounted: function() {},
  };
  </script>
  
  <style>
.pw-reset-form .el-button{
  margin-top: 12px;
  margin-bottom: 25px;
}
  </style>
  