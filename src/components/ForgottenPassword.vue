<template>
  <div v-if="state == ''">
    <el-form class="pw-reset-form" label-width="0px">
      <el-col :span="24">
        <el-form-item label>
          <el-input placeholder="Enter email address" name="login" autocomplete="none" v-model="form.login" size="medium"
            clearable></el-input>
        </el-form-item>
        <el-button class="login-button" @click="startPasswordReset()" type="primary" size="default">Send password
          Reset</el-button>
        <div class="login_error" v-if="form.error">{{ form.error }}</div>
      </el-col>
    </el-form>
  </div>
  <div v-else-if="state == 'token'">
    <el-form class="pw-reset-form" label-width="0px">
      <el-col :span="24">
        <el-form-item label>
          <el-input placeholder="Enter Token" name="token" v-model="form.token" size="medium"></el-input>
        </el-form-item>
        <el-button class="login-button" @click="checkToken()" type="primary" size="default">Check Token</el-button>
        <div class="login_error" v-if="form.error">{{ form.error }}</div>
      </el-col>
    </el-form>
  </div>
  <div v-else-if="state == 'password'">
    <el-form :model="ruleForm" class="pw-reset-form" label-width="0px" :rules="rules" status-icon ref="ruleForm">
      <el-col :span="24">
        <el-form-item label prop="pass">
          <el-input placeholder="Enter new Password" type="password" v-model="ruleForm.pass" size="small"></el-input>
        </el-form-item>
        <el-form-item label prop="checkPass">
            <el-input placeholder="Repeat new Password" type="password" v-model="ruleForm.checkPass" size="small"></el-input>
        </el-form-item>
        <el-button class="login-button" @click="sendNewPassword('ruleForm')" type="primary" size="default">Set New Password</el-button>
        <div class="login_error" v-if="form.error">{{ form.error }}</div>
      </el-col>
    </el-form>
  </div>
</template>
  
<script>
import axios from "axios";

export default {
  name: "forgottenPassword",
  data() {
    var validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('Please input the password'));
      } else {
        if (this.ruleForm.checkPass !== '') {
          this.$refs.ruleForm.validateField('checkPass');
        }
        callback();
      }
    };
    var validatePass2 = (rule, value, callback) => {
      if (value == '') {
        callback(new Error('Please input the password again'));
      } else if (value != this.ruleForm.pass) {
        callback(new Error('Two inputs don\'t match!'));
      } else {
        callback();
      }
    };
    return {
      ruleForm: {
        pass: '',
        checkPass: '',
      },
      rules: {
        pass: [
          { validator: validatePass, trigger: 'blur' }
        ],
        checkPass: [
          { validator: validatePass2, trigger: 'blur' }
        ]
      },
      form: {
        login: "",
        token: "",
        error: ""
      },
      state: "",
      token: ""
    }
  },
  props: {
    config: {
      type: Object
    }
  },
  methods: {
    async startPasswordReset() {
      const url = this.$store.getters.apiurl + "cred/forgottenpassword"
      const query = {
        login: this.form.login,
      };
      const response = await axios.post(url, query)
      if (response.data.error == "") {
        this.state="token"
        this.$notify({
          title: "Token Sent",
          message: "Check your email account",
          type: "success",
          position: "bottom-right"
        });
      } else {
        console.log("error: ",response.data.error )
        this.form.error = response.data.error;
      }
    },
    checkToken() {
      this.state="password";
    },
    async sendNewPassword(ruleForm) {
      console.log("lalalala" , this.$refs[ruleForm]);
      this.$refs[ruleForm].validate((valid) => {  
        if (valid) {
          this.apiCall()
        } 
      })
    },
    async apiCall(){
      const url = this.$store.getters.apiurl + "cred/resetpassword?token=" +this.token
      const query = {
        login: this.form.login,
        new_password: this.ruleForm.pass
      };
      const response = await axios.post(url, query)
      if (response.data.error == "") {
        this.state = "token";
        this.$notify({
          title: "New Password Set",
          message: "Loggin with your new password",
          type: "success",
          position: "bottom-right"
        });
      }
      this.$emit('error',response.data.error)
    },

  },
  created: function () { },

  mounted: function () { },
};
</script>
  
<style>
.pw-reset-form .el-button {
  margin-top: 12px;
  margin-bottom: 25px;
}
.login_error {
  margin-top: 10px;
  height: 30px;
  color: red;
}
</style>
  