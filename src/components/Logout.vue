<template>
  <span>
    <el-dropdown popper-class="nyx-popper" @command="handleCommand">
      <span class="el-dropdown-link" style="margin-top:5px">

      <el-button size="large" circle style="margin-top:7px;">
        <div
          style="width:16px;height:16px;font-size:14px;"
        >{{$store.getters.creds.user.firstname[0]}}</div>
      </el-button>
      </span>
      <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item command="info">
          <v-icon class="menuicon" icon="fa-info-circle" scale="1" />
          &nbsp;&nbsp;{{ $t("logout.info") }}
        </el-dropdown-item>
        <el-dropdown-item command="password">
          <v-icon class="menuicon" icon="fa-key" scale="1" />
          &nbsp;&nbsp;{{ $t("logout.change_pass") }}
        </el-dropdown-item>
        <el-dropdown-item divided command="logout">
          <v-icon class="menuicon" icon="fa-external-link-alt" scale="1" />
          &nbsp;&nbsp;{{ $t("logout.logout")}}
        </el-dropdown-item>
      </el-dropdown-menu>
      </template>
    </el-dropdown>
  </span>
</template>
  
<script>
export default {
  name: "Logout",
  data: () => ({}),
  props: {},
  created: function() {},
  methods: {
    handleCommand(e) {
      if (e == "info") this.info();
      else if (e == "password") {
        //this.password();
        this.$emit("changepassword");
      } else this.logout();
    },
    info() {
      this.$alert(
        "<strong>UI Version:</strong> " +
          this.$store.getters.version +
          "<br/><strong>API Version:</strong> "+this.$store.getters.apiVersion+ "<br/><strong>Window size:</strong> (" +
          this.$store.getters.containerSize.width +
          "," +
          this.$store.getters.containerSize.height +
          ")"
//         +"<br/><strong>Browser:</strong> "+this.$browserDetect.meta.name 
//          +"<br/><strong>Browser Version:</strong> "+this.$browserDetect.meta.version
          
          ,
        "Nyx Version",
        {
          confirmButtonText: "OK",
          dangerouslyUseHTMLString: true
        }
      );
    },
    logout() {
      console.log("BEFCOMMIT");
      this.$store.commit({
        type: "logout",
        data: {}
      });
      console.log("AFTERCOMMIT");
      this.$notify({
        title: this.$t("notifications.message"),
        message: this.$t("notifications.byebye"),
        type: "success",
        position: "bottom-right"
      });
      this.$router.push("/");
    }
  }
};
</script>

<style>
.menuicon {
  margin-bottom: -3px;
}
</style>