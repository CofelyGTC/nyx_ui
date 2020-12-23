<template>
  <div style="width: 100%">
    <el-row class="sendnotif-container" style="width: 100%" >
        <el-form>
        <el-row>
           
         <el-form-item label="Titre:" :label-width="formLabelWidth2">
             <el-input placeholder="ex: INFO, ATTENTION, etc..." size="mini" v-model="titleMessage" autocomplete="off"></el-input>
         </el-form-item>
        </el-row>
        <el-row>
            <el-form-item label="Message:" :label-width="formLabelWidth2">
                <el-input type="textarea" v-model="messageContent"></el-input>
            </el-form-item>
        </el-row>
        <el-row>
            <el-button type="primary" @click="sendMessage">Envoyer Message</el-button>
        </el-row>
        </el-form>
    </el-row>
    </div>
</template>
<script>
import Vue from "vue";
import axios from "axios";

export default {
  name: "SendNotif",
  data: () => ({
    titleMessage: '',
    messageContent: '',
    formLabelWidth2: "120px",
  }),
  props: {
    config: {
      type: Object
    }
  },
  created: function() {
    
  },
  methods: {

      sendMessage: function(){
          
          var token = this.$store.getters.creds.token
          var data={"notif_type":"global","notif_message_type":"info"
              ,"notif_title":this.titleMessage
              ,"notif_message":this.messageContent}
    
          var mess={"token":token,"type":"message","target":"UI","data":data}

          //var body1 = 

          var body = {
            "destination": "/topic/TO_UI",
            "body": JSON.stringify(mess)
            }
            
          console.log(body)
          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec envoi du message",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Message envoyé",
                    type: "success",
                    position: "bottom-right",
                    duration: 2000
                });
                }
            })
            .catch((error)=> {
            console.log(error);
            
            });
        }, 1000)

      }
 

  }
};

</script>
<style>

.box-card {
  width: 800px !important;
}

.first-row{
  margin: 10px;
}
.second-row{
  margin: 20px 10px;
}
.third-row{
  margin: 20px 10px;
}
.forth-row{
  margin: 20px 10px;
}

.table-disable {
  cursor: not-allowed;
}
.footer {
  position: fixed;
  left: 0;
  bottom: 1%;
  width: 100%;
  text-align: center;
}
</style>