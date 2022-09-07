<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="cake-editor"
  >
    <el-form v-model="newRec._source" :model="newRec._source" :rules="rules" ref="ruleForm" :disabled="disabled">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <el-form-item v-if="editableMagasin" label="Magasin" :label-width="formLabelWidth">
            <el-input :disabled="editableMagasin" size="mini" v-model="magasinStr" autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item v-else label="Magasin" :label-width="formLabelWidth2" prop="magasin">
            <el-select v-model="selectedShop" filterable placeholder="Sélectionner" @change="changeShop">
                    <el-option
                      v-for="(item, id) in magasins"
                      :key="id"
                      :label="item.shop + ' ('+ item.shopid+')'"
                      :value="[item.shop, item.shopid]">
                    </el-option>
                </el-select>
            </el-form-item>
          
          <el-row>
              <el-col :span=8>
                <el-form-item label="Nom" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.name" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span=8>  
                <el-form-item label="Prénom" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.firstname" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>  
              <el-col :span=8>  
                <el-form-item label="Téléphone" :label-width="formLabelWidth">
                    <el-input size="mini" v-model="newRec._source.phone" autocomplete="off"></el-input>
                </el-form-item>
              </el-col>  
          </el-row>
          <el-card shadow="hover" :body-style="{ padding: '10px' }">
          <h2>Composition:</h2>
          <el-row>
              <el-form-item label="Type de Gâteaux" :label-width="formLabelWidth2" prop="cake.type" >
                <el-select v-model="newRec._source.cake.type" filterable placeholder="Sélectionner" @change="changeCake">
                        <el-option v-for="(item, type) in cakeTypes" :key="type" :label="item" :value="item">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Number Cake'" label="Taille" :label-width="formLabelWidth2">
                    <el-select v-model="size" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, size) in sizesNumberCake" :key="size" :label="size" :value="size">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-else-if="newRec._source.cake.type == 'Glace'" label="Taille" :label-width="formLabelWidth2">
                    <el-select v-model="size" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, size) in sizesIce" :key="size" :label="size+' '+item.desc" :value="size">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-else label="Taille" :label-width="formLabelWidth2">
                    <el-select v-model="size" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, size) in sizes" :key="size" :label="size+' '+item.desc" :value="size">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Crème fraîche fruits'" label="Intérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.cremeGout1" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, cremeGout1) in cremeGout1" :key="cremeGout1" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Crème fraîche fruits'" label="Extérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.cremeGout2" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, cremeGout2) in cremeGout2" :key="cremeGout2" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Spécial Patron'" label="Intérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.patronGout1" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, patronGout1) in patronGout1" :key="patronGout1" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Spécial Patron'" label="Extérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.patronGout2" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, patronGout2) in patronGout2" :key="patronGout2" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="newRec._source.cake.type == 'Bavarois'" label="Goût Intérieur&Extérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.bavaroisType" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, bavaroisType) in bavaroisTypes" :key="bavaroisType" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <div v-if="newRec._source.cake.type == 'Glace'">
                  <el-form-item v-if="size == '4P' || size == '6P'" label="Goût" :label-width="formLabelWidth2" prop="taste">
                      <el-select v-model="glaceGoutSolo" filterable placeholder="Sélectionner">
                              <el-option v-for="(item, glaceGout) in glaceGouts" :key="glaceGout" :label="item" :value="item">
                              </el-option>
                      </el-select>
                  </el-form-item>
                  <el-form-item v-else label="Goût" :label-width="formLabelWidth2" prop="taste">
                      <el-select multiple :multiple-limit="2" v-model="glacesGoutDuo" filterable placeholder="Sélectionner">
                              <el-option v-for="(item, glaceGout) in glaceGouts" :key="glaceGout" :label="item" :value="item">
                              </el-option>
                      </el-select>
                  </el-form-item>
                </div>
                <el-form-item v-if="newRec._source.cake.type == 'Number Cake'" label="Saveur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.numberCakeType" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, numberCakeType) in numberCakeTypes" :key="numberCakeType" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <div v-if="newRec._source.cake.type == 'Number Cake'">
                    
                <el-form-item v-if="newRec._source.cake.numberCakeType != 'Crème Fraîche Nature'" label="Intérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.numberCakeGout" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, numberCakeGout1) in numberCakeGout1" :key="numberCakeGout1" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-else label="Intérieur" :label-width="formLabelWidth2" prop="taste">
                    <el-select v-model="newRec._source.cake.numberCakeGout" filterable placeholder="Sélectionner">
                            <el-option v-for="(item, numberCakeGout2) in numberCakeGout2" :key="numberCakeGout2" :label="item" :value="item">
                            </el-option>
                    </el-select>
                </el-form-item>



                    <el-form-item label="Caractères :" :label-width="formLabelWidth2" prop="caract">
                        <el-input :maxlength="maxLenNC" minlength="1" size="mini" v-model="newRec._source.cake.numberCakeChars" autocomplete="off" placeholder="Vos caractères" ></el-input>
                    </el-form-item>
                </div>
                
                <!--el-form-item label="Remarques :" :label-width="formLabelWidth2" >
                    <el-input size="mini" v-model="newRec._source.cake.remarqu run seres" autocomplete="off" placeholder="Vos remarque..."></el-input>
                </el-form-item-->
                <el-row>
                  <el-col :span=8>
                <el-form-item v-if="newRec._source.cake.type != 'Number Cake'" label="Envois photo par mail ?" :label-width="formLabelWidth2" > 
                  <el-switch v-model="imageByMail">
                  </el-switch>
                </el-form-item>
                  </el-col>
                  <el-col :span=8>
                <el-form-item v-if="imageByMail && newRec._source.cake.type != 'Number Cake'" label="Mail :" :label-width="formLabelWidth2" prop="mail">
                  <el-input size="mini" v-model="mail" autocomplete="off" placeholder="Mail expéditeur de l'image"></el-input>
                </el-form-item>
                  </el-col>
                  <el-col :span=8>
                    <el-form-item v-if="imageByMail && newRec._source.cake.type != 'Number Cake'" label="Description image :" :label-width="formLabelWidth2" prop="mailDesc">
                      <el-input size="mini" v-model="maildesc" autocomplete="off" placeholder="Description"></el-input>
                    </el-form-item>
                  </el-col>
                </el-row>
                <div v-if="newRec._source.cake.type != 'Number Cake'">
                  <el-row>
                    <el-col :span=8>
                  <el-form-item label="Inscription ?" :label-width="formLabelWidth2" > 
                    <el-switch v-model="isInscription" @change="changeInscription">
                    </el-switch>
                  </el-form-item>
                    </el-col>
                    <el-col :span=8>
                  <el-form-item v-if="isInscription" label="Inscription personnalisée ?" :label-width="formLabelWidth2" > 
                    <el-switch v-model="customInscription" @change="changeInscription">
                    </el-switch>
                  </el-form-item>
                    </el-col>
                    <el-col :span=8>
                  <el-form-item v-if="customInscription && isInscription" label="Inscription (sur le gâteaux):" :label-width="formLabelWidth" >
                      <el-input size="mini" v-model="inscription" autocomplete="off" placeholder="Inscription sur le Gâteaux"></el-input>
                  </el-form-item>
                  <el-form-item v-else-if="isInscription" label="Inscription :" :label-width="formLabelWidth2" >
                      <el-select v-model="inscription" filterable placeholder="Sélectionner">
                              <el-option v-for="(item, txt) in inscriptions" :key="txt" :label="item" :value="item">
                              </el-option>
                      </el-select>
                  </el-form-item>
                    </el-col>
                  </el-row>
                </div>
                  
                <div v-else>
                  <el-row>
                      <el-col :span=8>
                    <el-form-item label="Inscription ?" :label-width="formLabelWidth2" > 
                      <el-switch v-model="isInscription">
                      </el-switch>
                    </el-form-item>
                      </el-col>
                      <el-col :span=8>
                    <el-form-item v-if="isInscription" label="Inscription:" :label-width="formLabelWidth2" >
                        <el-select v-model="inscription" filterable placeholder="Sélectionner">
                                <el-option v-for="(item, txt) in inscriptions" :key="txt" :label="item" :value="item">
                                </el-option>
                        </el-select>
                    </el-form-item>
                      </el-col>
                    </el-row>
                </div>
                <el-row>
                  <el-col :span=6>
                <el-form-item label="Décorations ?" :label-width="formLabelWidth2" > 
                  <el-switch v-model="isDecoration">
                  </el-switch>
                </el-form-item>
                  </el-col>
                  <el-col :span=6>
                  <el-form-item v-if="isDecoration" label="Genre" :label-width="formLabelWidth2" prop="typeDeco">
                        <el-select v-model="newRec._source.cake.decoGender" filterable placeholder="Sélectionner">
                                <el-option v-for="(item, numberCakeGender) in numberCakeGenders" :key="numberCakeGender" :label="item" :value="item">
                                </el-option>
                        </el-select>
                    </el-form-item>
                  </el-col>
                  <el-col :span=6>
                <el-form-item v-if="isDecoration" label="Décorations :" :label-width="formLabelWidth2" prop="typeDeco">
                  <el-select v-model="decoration" filterable placeholder="Sélectionner">
                            <el-option v-for="(item1, txt1) in decorations" :key="txt1" :label="item1" :value="item1">
                            </el-option>
                    </el-select>
                </el-form-item>
                <!--el-form-item v-if="isDecoration" label="Décorations :" :label-width="formLabelWidth2" prop="typeDeco">
                  <el-select v-model="decoration" filterable placeholder="Sélectionner">
                            <el-option v-for="(item1, txt1) in decosTypes[newRec._source.cake.decoGender]" :key="txt1" :label="item1" :value="item1">
                            </el-option>
                    </el-select>
                </el-form-item-->
                  </el-col>
                  <el-col :span=6>
                <el-form-item v-if="isDecoration" label="Âge :" :label-width="formLabelWidth2" prop="age">
                      <el-input-number :min=0 size="mini" v-model="age">
                      </el-input-number>
                    
                </el-form-item>
                  </el-col>
                </el-row>
                
          </el-row>
          {{totalTTC}}€
          </el-card>
      
      <el-form-item>
        <el-button @click="$emit('dialogclose')">{{this.$t("buttons.cancel")}}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        :disabled="!recchanged"
        @click="saveRecord()"
      >{{this.$t("buttons.confirm")}}</el-button>
    <span slot="footer" class="dialog-footer">
      

      
    </span>
    </el-form-item>
    </el-card>
    <!--el-card>
      {{newRec._source}}
    </el-card-->
    
    
    </el-form>
  </el-dialog>
</template>

<script>
import Vue from "vue";

import YAML from "js-yaml";
import axios from "axios";

export default {
  name: "CakeEditor",
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: "",
    strNewRec: "",
    orgName: "",
    newName: "",
    formLabelWidth: "120px",
    formLabelWidth2: "180px",
    changed: false,
    dialogFormVisible: false,
    title: "Gâteaux",
    isDecoration: false,
    decoration: '',
    decorations: ['Anniversaire'],
    imageByMail: false,
    mail: '',
    maildesc: '',
    isInscription: false,
    customInscription: false,
    shop: '',
    shopid: '',
    selectedShop: '',
    inscription: '',
    isAdmin: false,
    inscriptions:['Bon anniversaire', 'Heureux Anniversaire', 'Joyeuses Fêtes', 'Bonnes Fêtes', 'Félicitations !'],
    cakeTypes: ['Crème fraîche fruits', 'Nutella', 'Spécial Patron', 'Schamp', 'Crème au Beurre Moka', 'Chocorêve', 'Mikkado', 'Bavarois', 'Glace', 'Number Cake'],
    size: '4P',
    sizes: {
        '4P':{'desc': '9,5 x 19,5 cm', 'prix': 14.4},
        '6P':{'desc': '14,5 x 19 cm', 'prix': 21.6},
        '8P':{'desc': '19 x 19,5 cm', 'prix': 28.8},
        '12P':{'desc': '19,5 x 28 cm', 'prix': 43.2},
        '16P':{'desc': '19,5 x 40 cm', 'prix': 57.6},
        '20P':{'desc': '20 x 40 cm', 'prix': 72},
        '24P':{'desc': '26  x 40 cm', 'prix': 86.4}},
    sizesNumberCake: {
        '6P':{'desc': '14,5 x 19 cm', 'prix': 27},
        '8P':{'desc': '19 x 19,5 cm', 'prix': 36},
        '12P':{'desc': '19,5 x 28 cm', 'prix': 54},
        '16P':{'desc': '19,5 x 40 cm', 'prix': 72},
        '20P':{'desc': '20 x 40 cm', 'prix': 90},
        '24P':{'desc': '26  x 40 cm', 'prix': 108}},    
    sizesIce: {
        '4P':{'desc': '9,5 x 19,5 cm', 'prix': 15.2},
        '6P':{'desc': '14,5 x 19 cm', 'prix': 22.8},
        '8P':{'desc': '19 x 19,5 cm', 'prix': 30.4},
        '12P':{'desc': '19,5 x 28 cm', 'prix': 54.6},
        '16P':{'desc': '19,5 x 40 cm', 'prix': 60.8},
        '20P':{'desc': '20 x 40 cm', 'prix': 76},
        '24P':{'desc': '26  x 40 cm', 'prix': 91.2}},    
    //bavaroisTypes: ['Fruits des Bois', 'Fraise', 'Framboise', 'Bora Bora'],
    bavaroisTypes: ['Framboise', 'Fraises'],
    glaceGoutSolo: 'Vanille',
    glacesGoutDuo: ['Vanille', 'Chocolat'],
    glaceGouts: ['Vanille', 'Chocolat', 'Fraise', 'Framboise', 'Pabana'],
    cremeGout1: ['Fruits Mixtes', 'Framboises', 'Sans Fruits'],
    cremeGout2: ['Fruits frais', 'Sans Fruits'],
    patronGout1: ['Fruits Mixtes', 'Framboises', 'Fraises', 'Sans Fruits'],
    patronGout2: ['Fruits frais', 'Sans Fruits'],
    numberCakeTypes: ['Mousse fraise', 'Mousse framboise', 'Mousse Chocolat', 'Mousse Nutella', 'Mousse Pabana', 'Crème Fraîche Nature'],
    numberCakeGout1: ['Fruits Mixtes', 'Fruits Rouges', 'Sans Fruits'],
    numberCakeGout2: ['Fruits Mixtes', 'Fruits Rouges'],
    age: 0,
    decosTypes: {
      'Homme':['Macarons + Noeud papillons', 'Macarons + Assortiment Papa', 'Macarons + Mix Outils', 'Macarons + Kinder Oréo'],
      'Femme':['Macarons Roses + Pétales', 'Pastels', 'Déco Dorée', 'Habits Dame'],
      'Fille':['Fleur Rose', 'Pastels'],
      'Garçon':['Macarons + Kinder Oreo', 'Foot', 'Pirates'],
      'Baby Girl':['Licorne', 'Papillons'],
      'Baby Boy':['Animaux', 'Minions'],
      'Autre':['-']
    },
    

    numberCakeGenders: ['Homme', 'Femme', 'Fille', 'Garçon', 'Baby Boy', 'Baby Girl', 'Autre'],
    magasins: [],
    rules: {
          cake: {type: [{ required: true, message: 'Veuillez sélectionner un type de gâteaux', trigger: 'blur' }]},
          taste: [{ required: true, message: 'Veuillez sélectionner un goût', trigger: 'blur' }],
          magasin: [{ required: true, message: 'Veuillez sélectionner un magasin', trigger: 'blur' }],
          caract: [{ required: true, message: 'Veuillez entrer les caractères du gâteau', trigger: 'blur' }],
          numberDeco: [{required: true, message: 'Veuillez choisir une décoration', trigger: 'blur'}],
          typeDeco: [{required: true, message: 'Veuillez choisir une décoration', trigger: 'blur'}],
          age:  [{required: true, message: 'Veuillez entrer un âge', trigger: 'blur'}],
          mail:  [{required: true, message: 'Veuillez entrez un format email correct', trigger: 'blur'}],
          mailDesc:  [{required: true, message: 'Veuillez remplir ces informations', trigger: 'blur'}],
    }
    


  }),
  computed: {
    recordin: function() {
      return this.record;
    },
    recordstr: function() {
      return JSON.stringify(this.record);
    },
    recchanged: function() {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec);
    },
    disabled: function() {
      if(this.$store.getters.timeRangeDay[0].getTime() < Date.now()+172800000 && !this.isAdmin )
      {
        return true
      }
      else
      {
        return false
      }
    },
    editableMagasin: function() {
        console.log('Active APP:')
        console.log(this.$store.getters.maintitle)
        console.log(this.$store.getters.mainsubtitle)
        console.log(this.$store.getters.currentSubCategory.fulltitle)
        if(this.$store.getters.currentSubCategory.fulltitle=='commandes/gâteaux')
        {
            return true
        }
        else{
            return false
        }
        
    },
    maxLenNC: function()
    {
      var maxLen = 1
      switch(this.size)
      {
        case '6P':
        case '8P':
        {
            maxLen = 1;
            break;
        }
        case '12P':
        case '16P':
        {
            maxLen = 2;
            break;
        }
        case '20P':
        case '24P':
        {
            maxLen = 3;
            break;
        }
      }
      return maxLen
    },
    /*magasin: function()
    {
        var magasin = 'TEST'
        if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
        {
            console.log('coucou1')
            console.log(this.$store.getters.activeApp.config.hiddenQuery.substring(9))
            console.log('coucou2')
            console.log(this.$store.getters.actualShop)
            console.log('coucou3')
            magasin = this.$store.getters.activeApp.config.hiddenQuery.substring(9)

            magasin = magasin.replace('"', '')
         
            
        
            //magasin = this.$store.getters.actualShop
            
        }
        return magasin.replace('"', '')
    },*/
    magasinStr: function()
    {
      var magasin = 'TEST'
        if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
        {
            
            console.log('coucou1')
            console.log(this.$store.getters.activeApp.config.hiddenQuery.substring(9))
            console.log('coucou2')
            console.log(this.$store.getters.actualShop)
            console.log('coucou3')
            //magasin = this.$store.getters.activeApp.config.hiddenQuery.substring(9)

            //magasin = magasin.replace('"', '')
            var magasin = this.$store.getters.actualShop+' ('+this.$store.getters.actualShopID+')'

         
            
        
            //magasin = this.$store.getters.actualShop
            
        }
        return magasin.replace('"', '')

    },
    totalTTC: function() {
        var price = 0
        if(this.newRec._source.cake.type == 'Number Cake'){
            var sizes = this.sizesNumberCake
          var size = this.size

          price = sizes[size].prix
        }
        else if(this.newRec._source.cake.type == 'Glace'){

          var sizes = this.sizesIce
          var size = this.size
          console.log(size)

          price = sizes[size].prix
          console.log(price)
        }
        else
        {
          console.log('In else')
          var sizes = this.sizes
          var size = this.size
          console.log(size)

          price = sizes[size].prix
          console.log(price)
        }



        if((this.isInscription && this.customInscription) || (this.isInscription && this.newRec._source.cake.type == 'Number Cake'))
        {
          price += 5
        }
        else if(this.isInscription)
        {
          price += 1.5
        }

        if(this.imageByMail)
        {
          switch(size)
          {
            case '4P':
            case '6P':
            {
              price+=5
              break;
            }
            case '8P':
            case '10P':  
            case '12P':
            {
              price+=7.5
              break;
            }
            case '16P':
            case '20P':  
            case '24P':
            {
              price+=10
              break;
            }
          }
        }

        if(this.isDecoration)
        {
          console.log('coucou')
          switch(size)
          {
            case '4P':
            case '6P':
            case '8P':
            {
            price+=2.5
            break;
            }
            case '10P':
            case '12P':  
            case '16P':
            {
            price+=5
            break;
            }
            case '20P':
            case '24P':
            {
            price+=7.5
            break;
            }
          }
        }

        return price
    }
  },
  props: {
    record: {
      type: Object
    },
    config: {
      type: Object
    },
    editMode: {
      type: String
    }
  },
  watch: {
    recordin: {
      handler: function() {
        this.prepareData();
      },
      deep: true
    }
  },
  created: function() {
    console.log("created event");
    this.getMagasins();
    this.size = this.record._source.cake.size
    this.isDecoration = this.record._source.cake.isDecoration
    this.decoration = this.record._source.cake.decoration
    this.imageByMail = this.record._source.cake.imageByMail 
    this.mail = this.record._source.cake.mail
    this.maildesc = this.record._source.cake.maildesc
    this.isInscription = this.record._source.cake.isInscription
    this.inscription = this.record._source.cake.inscription
    this.record._source.cake.type = this.record._source.type
    this.totalTTC = this.record._source.price
    this.customInscription = this.record._source.cake.customInscription
    console.log()
    if('glaceGouts' in this.record._source.cake)
    {

      this.glacesGoutDuo = this.record._source.cake.glaceGouts
    }

    if('decoAge' in this.record._source.cake)
    {

      this.age = this.record._source.cake.decoAge
    }
      
    //this.getMagasins();
    
    this.prepareData();
  },
  components: {},
  methods: {
    closeDialog: function() {
      this.$emit("dialogclose");
    },

    submitForm(formName) {

        var validate = false
        this.$refs[formName].validate((valid) => {
          console.log('coucou1')
          if (valid) {
            //alert('submit!');
            //saveRecord();
            console.log('Rules OK')
            validate = true;
            
          } else {
            console.log('error submit!!');
            validate = false;
          }
        });

        //return validate;
        /*this.$refs[formName].validate((valid) => {
          console.log('coucou1')
          console.log(valid)
*/
      },

    changeInscription(){
      this.inscription = '';
    },
      
    changeCake(selected) {
      console.log(selected)
      if(selected == 'Number Cake' && this.size == '4P')
      {
        this.size = '6P'
      }
    }, 

    getMagasins() {         
      var url =
      this.$store.getters.apiurl +
      "generic_search/shop_parameters?token=" + this.$store.getters.creds.token;  

      console.log('CHECK SHOPS LIST')

      console.log("PRIVILEGES")
      console.log(this.$store.getters.privileges)
      console.log("PRIVILEGES")
      
      for(var priv in this.$store.getters.privileges)
      {
        console.log(this.$store.getters.privileges[priv]["_source"]["value"])
        if(this.$store.getters.privileges[priv]["_source"]["value"] == "admin")
        {
          this.isAdmin = true;
          console.log("THIS IS ADMIN")
        }
              
      }

      var query = {
        size: 2000,
        sort:[{"Nom magasin.keyword":{"order":"asc"}}],
        query: {
          bool: {
            must: [
              {
                match_all: {}
              }
            ]
          }
        }
      };

      axios
        .post(url, query)
        .then((response) => {
            if(response.data.error!="")
            console.log("User Shop list error...");
            else{
                
                var res = response.data
                console.log("MAGASINS : ")
                console.log(res)
                this.magasin = res.records[0]._source['Nom magasin']
                this.shopid = res.records[0]._source['shopid']
                var magasins = []
                for(var rec in res.records)
                {
                    console.log(rec)
                    var shop = {"shop": res.records[rec]._source['Nom magasin'], "shopid": res.records[rec]._source['shopid']}
                    magasins.push(shop)
                }
                this.magasins = magasins
                console.log(this.magasins)
                this.prepareData();
               
            }
        });  

        

    },
    changeShop(){
      console.log("CHANGE SHOP")
      console.log(this.selectedShop)
      //console.log(item)
      //this.magasin = magasin
      this.shop = this.selectedShop[0]
      this.shopid = this.selectedShop[1]
      console.log("SHOP: " + this.shop)
      console.log("SHOPID: " + this.shopid)
      this.newRec._source.magasin = this.shop
      console.log(this.newRec._source.magasin)
      this.$store.commit({
        type: "setActualShop",
        data: this.shop
      });
      this.$store.commit({
        type: "setActualShopID",
        data: this.shopid
      });
      console.log('TESTESTEST')
      console.log(this.$store.getters.actualShop)
      this.prepareData();
    },
    prepareData: function() {
      console.log("prepare data");
      this.dialogFormVisible = true;
      if(!this.record._source.cake)
      {
          this.record._source.cake = {}
      }
      this.newRec = JSON.parse(JSON.stringify(this.record));
      this.orgRec = JSON.parse(JSON.stringify(this.record));
      if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
      {
          this.newRec._source.magasin = this.magasin
          this.selectedShop = this.magasin
      }
    },
    saveRecord: function() {

      console.log(this.newRec._source.cake.type)
      if(this.newRec._source.cake.type == null || this.selectedShop == '' || (this.newRec._source.cake.type == 'Bavarois' && this.newRec._source.cake.bavaroisType == null) || (this.newRec._source.cake.type == 'Crème fraîche fruits' && this.newRec._source.cake.cremeGout1 == null)|| (this.newRec._source.cake.type == 'Crème fraîche fruits' && this.newRec._source.cake.cremeGout2 == null)|| (this.newRec._source.cake.type == 'Spécial Patron' && this.newRec._source.cake.patronGout1 == null)|| (this.newRec._source.cake.type == 'Spécial Patron' && this.newRec._source.cake.patronGout2 == null) || (this.newRec._source.cake.type == 'Glace' && this.glaceGoutSolo == '' && this.glacesGoutDuo.length == 0) ||(this.newRec._source.cake.type == 'Number Cake' && (this.newRec._source.cake.numberCakeType == null || this.newRec._source.cake.numberCakeChars == null )))
      {
          console.log('In if')
          console.log(this.newRec._source.magasin)
          console.log(this.selectedShop)

          this.submitForm('ruleForm')
          //console.log(this.newRec._source.cake.glaceGout)   
      }

      else if (this.isDecoration == true && (this.newRec._source.cake.decoGender == '' || this.decoration =='' || this.age == 0))
      {
        this.submitForm('ruleForm')
      }
      else if (this.imageByMail == true &&  (!this.mail.includes('@') || !this.mail.includes('.')))
      {
        this.submitForm('ruleForm')
      }
      else if (this.imageByMail == true && this.maildesc == '')
      {
        this.submitForm('ruleForm')
      }
      /*else if(this.newRec._source.cake.type == 'Glace' && this.newRec._source.cake.glaceGouts == [])
      {
          this.submitForm('ruleForm')
      }
      else if(this.newRec._source.cake.type == 'Number Cake' && (this.newRec._source.cake.numberCakeTypes == null || this.newRec._source.cake.numberCakeChars == null))
      {
          this.submitForm('ruleForm')
      }

      if(!this.submitForm('ruleForm'))
      {
        console.log('Rules unsuceed')
      }*/


      else{
        console.log(this.newRec._source.cake.glaceGout)
        console.log('in else')
        this.newRec._source.modifyBy = this.$store.getters.creds.user.login
        this.newRec._source.dateOrder = Date.now()
        this.newRec._source.dateDelivery = this.$store.getters.timeRangeDay[0].getTime()
        console.log(Date.now())
        console.log(this.$store.getters.timeRangeDay[0].getTime())
        
        if(this.editableMagasin)
        {
          this.shop = this.$store.getters.actualShop
          this.shopid = this.$store.getters.actualShopID
        }
        
        this.newRec._source.magasin = this.shop
        this.newRec._source.shopid = this.shopid
        this.newRec._source.cake.size = this.size
        this.newRec._source.cake.isDecoration = this.isDecoration
        this.newRec._source.cake.decoration = this.decoration
        this.newRec._source.cake.imageByMail = this.imageByMail
        this.newRec._source.cake.mail = this.mail
        this.newRec._source.cake.maildesc = this.maildesc
        this.newRec._source.cake.isInscription = this.isInscription
        this.newRec._source.cake.inscription = this.inscription
        this.newRec._source.cake.customInscription = this.customInscription
        this.newRec._source.type = this.newRec._source.cake.type
        this.newRec._source.price = this.totalTTC
        this.newRec._source.cake.decoAge = this.age

        if(this.newRec._source.type == 'Number Cake' && this.newRec._source.age == null)
        {
          this.newRec._source.age = 0
        }

        if(this.newRec._source.type == 'Glace')
        {
          if(this.newRec._source.size=='4P' || this.newRec._source.size=='6P')
          {
            this.newRec._source.cake.glaceGouts = [this.glaceGoutSolo, '-']
          }
          else
          {
            this.newRec._source.cake.glaceGouts = this.glacesGoutDuo;
          }
        }

        /*if(this.$store.getters.currentSubCategory.fulltitle == 'commandes/gâteaux')
        {
            this.newRec._source.magasin = this.magasin
        }*/

        console.log(this.newRec)

        this.$store.commit({
          type: "updateRecord",
          data: this.newRec
        });
        this.$notify({ 
          title: "Record saved.",
          type: "success",
          message: "La commande a été enregistrée.",
          position: "bottom-right"
        });
        this.$emit("dialogcloseupdated");
      }
    }
  }
};
</script>

<style >
.bhd-tech-editor .view-table {
  margin-bottom: 30px;
}
.bhd-tech-editor .screen-name-input {
  margin-bottom: 10px;
}

.bhd-tech-editor .add-view-button {
  margin-bottom: 30px;
}

</style>