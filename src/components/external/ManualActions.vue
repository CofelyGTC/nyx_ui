<template>
  <div style="width: 100%">
    <el-row class="manualactions-container" style="width: 100%" >
        <el-row>ACTIONS :</el-row>
        <el-row>
        <el-button type="primary" @click="onConfirm">Confirmer Commandes</el-button>
        <el-button type="primary" @click="onClose">Cloturer commandes</el-button>
        <el-button type="primary" @click="onReopen">Réouvir Commandes</el-button>
        <el-button type="primary" @click="onCompile">Compiler Production</el-button>
        </el-row>
        <el-row>
        <el-button type="primary" @click="onReorder">Repasser les Commandes</el-button>
        <el-button type="primary" @click="onGenerateLivraison">Générer Bons de livraison</el-button>
        <el-button type="primary" @click="onGenerateLivraisonDetails">Générer détails préparation</el-button>
        <el-button type="primary" @click="onGenerateComission">Générer notes de livraisons</el-button>
        </el-row>
        <el-row>
          <el-button type="primary" @click="test">TEST</el-button>
        </el-row>
    </el-row>
    </div>
</template>
<script>
import Vue from "vue";
import axios from "axios";

export default {
  name: "ManualActions",
  data: () => ({}),
  props: {
    config: {
      type: Object
    }
  },
  created: function() {
  },
  methods: {
      onConfirm(){
        var body = {
            "destination": "/topic/CONFIRM_ORDERS",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec de la confirmation des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes envoyées à la confirmation",
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

        console.log('Confirming Commands')
      },
      onReorder(){
        var body = {
            "destination": "/topic/REORDER",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec du repassage des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes repassées",
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

        console.log('Confirming Reorder')
      },
      test(){
        var body = {
            "destination": "/queue/TEST1",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec du repassage des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "TEST SEND",
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

        console.log('TEST')
      },
      onClose(){
        var body = {
            "destination": "/topic/CLOSE_ORDERS",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec de la fermeture des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes clôturées",
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

        console.log('Confirming Commands')
      },
      onReopen(){
        var body = {
            "destination": "/topic/REOPEN_ORDERS",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec de la réouverture des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes réouvertes",
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

        console.log('Confirming Commands')
      },
      onCompile(){
        var body = {
            "destination": "/topic/COMPILE_ORDERS",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec de la compilation des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes envoyées à la confirmation",
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

        console.log('Confirming Commands')
      },
      onGenerateComission(){
        var body = {
            "destination": "/topic/GENERATE_COMISSION_DAY",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec du repassage des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Bons de livraison finaux OK",
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

        console.log('Confirming Reorder')
      },
      onGenerateLivraison(){
        var body = {
            "destination": "/topic/GENERATE_BON_LIVRAISON",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec du repassage des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes repassées",
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

        console.log('Confirming Reorder')
      },
      onGenerateLivraisonDetails(){
        var body = {
            "destination": "/topic/GENERATE_LIVRAISON_DETAILS",
            "body": "{'message':'stop'}"
            }

          setTimeout(() => {
            axios.post(
            this.$store.getters.apiurl + "sendmessage?token="+this.$store.getters.creds.token, body
            ).then((response) => {
                if(response.data.error!="")
                {
                    this.$notify({ 
                    title: "Error",
                    message: "Echec du repassage des commandes",
                    type: "error",
                    position: "bottom-right",
                    duration: 1500});
                    }
                else
                {
                    this.$notify({ 
                    title: "Success",
                    message: "Commandes repassées",
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

        console.log('Confirming Reorder')
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