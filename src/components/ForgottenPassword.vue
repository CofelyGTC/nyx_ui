<template>
    <el-form class="pw-reset-form" label-width="0px">
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
          <el-button
            class="login-button"
            @click="sendPasswordReset()"
            type="primary"
            size="default"
            color="#048"
          >Send password Reset</el-button>
        </el-col>
    </el-form>
</template>
  
  <script>
  // import axios from "axios";
  
  export default {
    name: "forgottenPassword",
    data: () => ({
        form:{
            login:""
        }
    }),
    props: {
      config: {
        type: Object
      }
    },
    methods: {},
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
  