<template>
  
  <div class="login-container">
    <img class="logo-group" src="../assets/quantesx.png">
    <img class="logo-team" src="../assets/equansDigital.png">
    <div class="logo-container" style="display: none;">
      <div class="title-icon"></div>
      <div class="login-logo1">
      </div>
      <div class="title-icon2">
        <v-icon style="color:white" name="spinner" scale="3" spin v-if="!initialized || loginunderway" />
        <v-icon style="color:white" :name="config.icon" scale="3" v-if="initialized && !loginunderway" />
      </div>
    </div>

<div class="title-disclaimer">
  <b>Nyx</b> Platform <b>{{this.$store.getters.version}}</b> ({{$store.getters.elasticVersion}})
</div>
    <el-card class="login-card" :body-style="{padding:'25px 25px'}" shadow="hover">
      <div class="login-choice-card" v-if="!userPassword">
        <el-button
        class="login-button email-button"
        @click="useEmail()"
        type="secondary"
        size="default"
        >
        <v-icon style="color:#DCDFE6" name="regular/envelope" scale="1.8"></v-icon>
        Login using Email</el-button>
        <!--a :href="azure_url" target="popup" -->
        <el-button
              class="login-button equans-login-button"
              type="primary"
              size="default"
              @click="openPopup()"
            >
            <img class="equans-logo" src="../assets/EQUANS.png" height="40"/>
            Equans Login</el-button>
            <!--/a-->
            <div class="login_error" v-if="azureError">{{azureError}}</div>
      </div>
      <el-form class="login-form" label-width="0px" v-if="userPassword && !resetPassword" >
        <el-col :span="24">
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
          <el-form-item label>
            <el-input
              placeholder="Password"
              v-on:keyup.enter.native="validateUser()"
              type="password"
              name="password"
              autocomplete="none"
              v-model="form.password"
              size="medium"
            />
          </el-form-item>
            <el-button
              class="login-button"
              @click="validateUser()"
              type="primary"
              size="default"
              color="#048"
              :disabled="loginDisabled"
              :loading="loginunderway"
            >Login</el-button>
          <div>
            <a @click="forgottenPassword()" class="forgottenPassword">Forgot password?</a>
          </div>
          <div class="login_error" v-if="form.error">{{form.error}}</div>
        </el-col>
      </el-form>
      <ForgottenPassword v-if="resetPassword" @error="forgottenPasswordAction($event)"/>
    </el-card>
    <h1 class="title-login" style="display: none;">
      {{config.welcome}}
    </h1>

  </div>
</template>

<script>
/* eslint-disable */

import Vue from "vue";
import axios from "axios";
import forgottenPassword from "@/components/ForgottenPassword";
import { loadLanguageAsync } from "../i18n-setup";

Vue.component("ForgottenPassword",forgottenPassword)

function getUrlVars() {
  var vars = {};
  var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(
    m,
    key,
    value
  ) {
    vars[key] = value;
  });
  return vars;
}

export default {
  data: () => ({
    userPassword: false,
    form: {
      login: "",
      password: "",
      error: ""
    },
    config: {
      icon: "fingerprint",
      welcome: "loading"
    },
    loginunderway: false,
    initialized: false,
    azure_url: "",
    azureunderway: false,
    azureError:"",
    //cardHeight: 110,
    resetPassword: false
  }),
  created: async function() {
    var vars = getUrlVars();
    this.getAzureUrl();
    setTimeout(this.loadConfig, 1000);
  },
  methods: {
    forgottenPasswordAction(error){d
      this.resetPassword=false;
      this.form.error=error;
    },
    forgottenPassword(){
      this.resetPassword=true
    },
    async getAzureUrl(){
      this.azureunderway = true;
      const response = await axios.get(
        this.$store.getters.apiurl + "checkstate?loggedout=" + this.$store.getters.loggedOut,{
          withCredentials:true
        }
      );
      
      console.log('response.data: ', response.data);
      //var response.data= await JSON.parse(response.data)
      if (response.data.skipActiveDirectory){
        this.userPassword=true;
      }
      if(response.data.azureSignedIn){
        console.log("Azure signed in, signing in");
        this.validateUser("azure/secondstep");
      }else{
        console.log("Azure not signed in, retrieving url: ", response.data.url )
        this.azure_url=await response.data.url;
        this.azureunderway = false;
      }
    },
    async openPopup(){
      var width = 650; // Width of the new window
      var height = 700; // Height of the new window
      
      // Calculate the center position
      var left = (window.innerWidth - width) / 2;
      console.log('left: ', left);
      var top = (window.innerHeight - height) / 2;
      console.log('top: ', top);

      // Define window features
      //var features = `width=${width},height=${height},left=${left},top=${top}`;
      var features = this.popupCenter(width,height)
      console.log('features: ', features);

      var win = window.open('about:blank', '_blank', features);
      win.location.href = this.azure_url;
      console.log('this.azure_url: ', this.azure_url);
      
      //let win=window.open(this.azure_url,"popup",features);
      this.azureunderway=true;
      console.log("entering loop, wainting for azure signin")
      while (!win.closed&&this.azureunderway){
        this.loopApi(win)
        await new Promise(resolve => setTimeout(resolve, 500));
      }
      this.azureunderway=false;
      console.log("Loop over, Logged in")
    },
    popupCenter(w, h) {
      // Fixes dual-screen position                             Most browsers      Firefox
      const dualScreenLeft = window.screenLeft !==  undefined ? window.screenLeft : window.screenX;
      const dualScreenTop = window.screenTop !==  undefined   ? window.screenTop  : window.screenY;

      const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
      const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

      const systemZoom = width / window.screen.availWidth;
      const left = (width - w) / 2 / systemZoom + dualScreenLeft
      const top = (height - h) / 2 / systemZoom + dualScreenTop
      const features =`width=${w}, height=${h}, top=${top}, left=${left} `
      return features
    },
    async loopApi(win){
      const response = await axios.get(
        this.$store.getters.apiurl + "azure/finished",
        {withCredentials:true}
      );

      if (response.data.error){
        this.azureunderway=false
        console.log("errror AZURE")
        win.close()
        //ADD message
      }else{
        if(response.data.finished){
          this.azureunderway=false;
          this.validateUser("azure/secondstep");
          win.close()
        }
        return;
      }
    },
    async loadConfig() {
      const response = await axios.get(
        this.$store.getters.apiurl + "config",
        {}
      );

      if (response.data.error == "") {
        this.initialized = true;
        this.config = response.data;

        if(response.data.elastic_version != null) {
          this.$store.commit({
            type: "elasticVersion",
            data: response.data.elastic_version
          });
        }

      }
    },
    useEmail(){
      this.userPassword=true;
      //this.cardHeight=150;
    },
    
    async validateUser(endpoint="cred/login") {
      try {
        let response
        this.loginunderway = true;
        if(endpoint=="azure/secondstep"){
          response = await axios.get(
            this.$store.getters.apiurl + endpoint,
            { 
              withCredentials:true
            }
          );
        }else{
          response = await axios.post(
            this.$store.getters.apiurl + endpoint,
            {
                login: this.form.login, 
                password: this.form.password
            },          
          );
        }

        console.log('response.data.error: ', response.data.error);
        if (response.data.error == "") {
          this.authenticate(response);
        } else {
          this.loginunderway = false;

          if (response.data.error == "DoublePhase") {
            this.$prompt("Please input your code", "Second Phase", {
              confirmButtonText: "OK",
              cancelButtonText: "Cancel",
              inputPattern: /[0-9]{5}/,
              inputErrorMessage: "Invalid Code"
            })
              .then(({ value }) => {
                // Try to login with double phase
                axios
                  .post(this.$store.getters.apiurl + "cred/login", {
                    login: this.form.login,
                    password: this.form.password,
                    doublecode: value
                  })
                  .then(response => {
                    if (response.data.error != "")
                      console.log("Double AUth Error...");
                    else {
                      this.authenticate(response);
                    }
                  })
                  .catch(error => {
                    console.log(error);
                  });
              })
              .catch(() => {
                this.$message({
                  type: "info",
                  message: "Input canceled"
                });
              });
          } else {
            this.form.error = response.data.error;

          }
        }
      } catch (e) {
        this.form.error = e;
        this.loginunderway = false;
        console.log(e);
      }
    },
    async verifyVersion(version) {

      const resVersion = await axios.get("version");

      var curVer = resVersion.data.version

      
      if(version != curVer)
      {
        console.log(version)
        console.log(curVer)
        console.log("Must be reloaded")
        //window.location.reload()
        this.$store.commit({
          type: "ui_version",
          data: curVer
        });
      }
      else{
        console.log("Good Version")
      }
    },
    authenticate(response) {

      this.verifyVersion(this.$store.getters.version);
      
      console.log('LOGIN -- authenticate')

      localStorage.authResponse = JSON.stringify(response)

      this.$i18n.locale = response.data.cred.user.language;
      Vue.config.lang = response.data.cred.user.language;
      //alert(this.$i18n.locale);

      response.data.cred.user.user = this.form.login;
      this.$store.commit({
        type: "login",
        data: response.data
      });
      console.log('response.data: ', response.data);
      this.loginunderway = false;
      
      var rec_id = null
      try {
        
        rec_id  = this.$store.getters.filteredmenus[0].submenus[0].apps[0].rec_id
      }
      catch (e) {
        
        this.loginunderway = false;
        console.log(e);
        this.$router.push("/");
      }

      // var path = "/main/"+app.fulltitle.replace(/ /g,'').toLowerCase()
      var path = "/main/"+rec_id
      

      if(this.$store.getters.redirection) {
        console.log('REDIRECTION: '+this.$store.getters.redirection)
        path = this.$store.getters.redirection
        this.$store.state.redirection = null

        rec_id = path.replace('/main/', '')
      }

      this.$store.commit({
        type: "changeApp",
        data: rec_id
      });



      if(response.data.cred.user.privileges.includes('admin')) {
        // this.$store.dispatch("privileges");
        // this.$store.dispatch("filters");

        this.$store.commit({
          type: "privileges",
          data: response.data.all_priv
        });
        //alert(JSON.stringify(response.data.all_filters))
        this.$store.commit({
          type: "filters",
          data: response.data.all_filters
        });
      }
      console.log('push this path: '+path)
      this.$router.push(path);
      this.$store.commit({
        type: "version",
        data: response.data.version
      });
      this.$notify({
        title: this.$t("notifications.message"),
        message:
          this.$t("notifications.welcome") +
          " v(" +
          response.data.version +
          ")",
        type: "success",
        position: "bottom-right"
      });
      this.form.login = "";
      this.form.password = "";

      
        
      window.dispatchEvent(new Event("resize"));
    }
  },
  computed: {
    loginDisabled() {
      return (
        this.form.login.length == 0 ||
        this.form.password.length == 0 ||
        this.loginunderway
      );
    }
  },
  mounted: function() {

    var vars = getUrlVars();
    if (vars["user"] != undefined) {
      this.form.login = decodeURIComponent(vars["user"].split("#")[0]);
    }
    if (vars["password"] != undefined) {
      this.form.password = decodeURIComponent(vars["password"].split("#")[0]);
      if (vars["user"] != undefined) {
        this.validateUser()
      }
    }
  }
};
</script>

<style>
.loginheader {
  font-size: large;
  font-weight: bolder;
  color: #4376c8;
}
.login_error {
  margin-top: 10px;
  height: 30px;
  color: red;
}
.title-login {
  position: absolute;
  width: 100%;
  text-align: center;
  top: 50%;
  color: white;
  margin-top: 170px;
  font-family: "Helvetica Neue";
}

.title-disclaimer {
  position: absolute;
  text-align: center;
  bottom: 0%;
  right: 0%;
  color: white;
  font-family: "Helvetica Neue";
  padding:3px;
}

.title-icon {
  position: absolute;
  left: 50%;
  text-align: center;
  width: 100px;
  height: 100px;
  margin-left: -50px;
  margin-top: -190px;
  top: 50%;
  color: red;
  font-family: "Helvetica Neue";
  border: solid 2px white;
  border-radius: 80px;
}

.title-icon2 {
  position: absolute;
  left: 50%;
  text-align: center;
  width: 100px;
  height: 100px;
  margin-left: -48px;
  margin-top: -162px;
  top: 50%;
  color: red;
  font-family: "Helvetica Neue";
}

.login-button {
  width: 100%;
  margin-top: 10px;
}

.login-container {
  position: absolute;
  top: 0px;
  left: 0px;
  right: 0px;
  bottom: 0px;
  height: 100%;
  background-color: #048;
}

.login-card {
  position: absolute;
  left: 50%;
  top: 42%;
  width: 400px;
  transform: translateX(-50%);
  transition: height 3s;
}
.login-choice-card {
  position: relative;
}
.login-form .el-button{
  margin-top: 12px;
}
.login-choice-card .el-button{
  height:45px;
  border-radius: 6px;
  border-width: 2px;
}
.equans-login-button{
  margin-left:0 !important;
  margin-top:1em !important;
  position: relative;
}
.equans-logo{
  position:absolute;
  left:8%;
  top:-3%;
}
.login-choice-card .fa-icon{
  position:absolute;
  left:10%;
  top:7%
}
.logo-group {
  position: absolute;
  left: 50%;
  width: 300px;
  transform: translate(-50%,-100%);
  top: 40%;
}
.logo-team {
  position: absolute;
  left: 1%;
  width: 150px;
  top: 92%;
}
.forgottenPassword{
  float: left;
  margin-top: 0.3em;
  cursor: pointer;
}
</style>