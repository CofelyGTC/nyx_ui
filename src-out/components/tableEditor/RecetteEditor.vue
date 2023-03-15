<template>
  <el-dialog
    width="80%"
    :title="title"
    :visible.sync="dialogFormVisible"
    :before-close="closeDialog"
    :close-on-click-modal="false"
    class="recette-editor"
  >
    <el-form v-model="newRec._source">
      <el-card shadow="hover" :body-style="{ padding: '10px' }">
        <el-row>
          <el-col :span="12">
            <el-form-item label="Produit: " :label-width="formLabelWidth">
              <el-select
                v-model="finalProduct"
                placeholder="Choisissez un produit"
                filterable
                size="small"
                @change="changeProduct"
              >
                <el-option
                  v-for="(_source, index) in this.finalProducts"
                  :key="index"
                  :value="[
                    _source['CODE'],
                    _source['Label'],
                    _source['Prix_TVAC'],
                    _source['HTVA'],
                  ]"
                  :label="_source['CODE'] + ' ' + _source['Label']"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="6">
            <el-form-item label="CODE: " :label-width="formLabelWidth2">
              {{ this.codeProduct }}
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="Label : " :label-width="formLabelWidth">
              {{ this.labelProduct }}
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="6">
            <el-form-item
              label="Prix unitaire de vente (HTVA): "
              :label-width="formLabelWidth2"
            >
              {{ this.prixUnitProductHTVA }} €
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item
              label="Prix unitaire : "
              :label-width="formLabelWidth"
            >
              {{ this.totalPriceUnit }} €
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="Marge : " :label-width="formLabelWidth">
              {{ this.prixUnitProductHTVA - this.totalPriceUnit }} €
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="6">
            <el-form-item label="Code" :label-width="formLabelWidth">
              <el-input
                :disabled="editMode != 'create'"
                size="small"
                v-model="newRec._source.code"
                autocomplete="off"
              ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="Poids" :label-width="formLabelWidth">
              <el-input-number
                size="small"
                v-model="newRec._source.weight"
                :min="0"
              ></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="Unité" :label-width="formLabelWidth">
              <el-input
                size="small"
                v-model="newRec._source.unity"
                autocomplete="off"
              ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="Prix au kg" :label-width="formLabelWidth">
              {{ totalPrice }} €
            </el-form-item>
          </el-col>
        </el-row>
        <el-row style="text-align: left">
          <el-col>
            <h2>Ingrédients :</h2>
          </el-col>
          <el-col
            v-for="(ingredient, index) in this.newRec._source.ingredients"
            :key="index"
          >
            <el-row>
              <el-col :span="3">
                <el-form-item label="Code Ingr." :label-width="formLabelWidth">
                  {{ ingredient.code }}
                </el-form-item>
              </el-col>
              <el-col :span="9">
                <el-form-item label="Ingr." :label-width="formLabelWidth">
                  {{ ingredient.name }}
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Quantity" :label-width="formLabelWidth">
                  <el-input-number
                    size="small"
                    v-model="ingredient.quantity"
                    :min="0"
                    @change="$forceUpdate()"
                  ></el-input-number>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-form-item label="Prix kg: " :label-width="formLabelWidth">
                  {{ ingredient.pricekg }} €
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Prix : " :label-width="formLabelWidth">
                  {{ ingredient.price }} €
                </el-form-item>
              </el-col>

              <el-col :span="1">
                <el-button
                  @click="removeIngredient(index)"
                  type="danger"
                  :icon="ElIconDelete"
                  circle
                >
                </el-button>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row style="text-align: left">
          <el-col :span="4">
            <label>Ajouter ingrédient : </label>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="newIngredient"
              placeholder="Choisissez un ingrédient"
              filterable
              size="small"
            >
              <el-option
                v-for="(_source, index) in this.allIngredients"
                :key="index"
                :value="[
                  _source._source['Code ingrédient'],
                  _source._source['Ingrédient'],
                  _source._source['Prix kg'],
                ]"
                :label="
                  _source._source['Code ingrédient'] +
                  ' ' +
                  _source._source['Ingrédient']
                "
              ></el-option>
            </el-select>
          </el-col>
          <el-col :span="3">
            <label>Quantité : </label>
          </el-col>
          <el-col :span="3">
            <el-input-number
              size="small"
              v-model="newIngredientQuantity"
              :min="0"
              :model-value="1"
            ></el-input-number>
          </el-col>
          <el-col :span="4">
            <el-button
              type="primary"
              @click="addIngredient()"
              :icon="ElIconPlus"
              circle
            ></el-button>
          </el-col>
        </el-row>

        <el-row style="text-align: left">
          <el-col>
            <h2>Produits semis-finis :</h2>
          </el-col>
          <el-col
            v-for="(produit, index) in this.newRec._source.produits"
            :key="index"
          >
            <el-row>
              <el-col :span="3">
                <el-form-item label="Code Ingr." :label-width="formLabelWidth">
                  {{ produit.code }}
                </el-form-item>
              </el-col>
              <el-col :span="9">
                <el-form-item label="Ingr." :label-width="formLabelWidth">
                  {{ produit.name }}
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Quantity" :label-width="formLabelWidth">
                  <el-input-number
                    size="small"
                    v-model="produit.quantity"
                    :min="0"
                    @change="$forceUpdate()"
                  ></el-input-number>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-form-item label="Prix kg: " :label-width="formLabelWidth">
                  {{ produit.pricekg }} €
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Prix : " :label-width="formLabelWidth">
                  {{ produit.price }} €
                </el-form-item>
              </el-col>

              <el-col :span="1">
                <el-button
                  @click="removeProduit(index)"
                  type="danger"
                  :icon="ElIconDelete"
                  circle
                >
                </el-button>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row style="text-align: left">
          <el-col :span="4">
            <label>Ajouter Produit : </label>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="newProduit"
              placeholder="Choisissez un produit"
              filterable
              size="small"
            >
              <el-option
                v-for="(_source, index) in this.allProduits"
                :key="index"
                :value="[
                  _source._source['code'],
                  _source._source['label'],
                  _source._source['price'],
                ]"
                :label="
                  _source._source['code'] + ' ' + _source._source['label']
                "
              ></el-option>
            </el-select>
          </el-col>
          <el-col :span="3">
            <label>Quantité : </label>
          </el-col>
          <el-col :span="3">
            <el-input-number
              size="small"
              v-model="newProduitQuantity"
              :min="0"
              :model-value="1"
            ></el-input-number>
          </el-col>
          <el-col :span="4">
            <el-button
              type="primary"
              @click="addProduit()"
              :icon="ElIconPlus"
              circle
            ></el-button>
          </el-col>
        </el-row>

        <el-row style="text-align: left">
          <el-col>
            <h2>Packaging :</h2>
          </el-col>
          <el-col
            v-for="(pack, index) in this.newRec._source.packaging"
            :key="index"
          >
            <el-row>
              <el-col :span="3">
                <el-form-item label="Code Prod." :label-width="formLabelWidth">
                  {{ pack.code }}
                </el-form-item>
              </el-col>
              <el-col :span="9">
                <el-form-item label="Pack." :label-width="formLabelWidth">
                  {{ pack.name }}
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Quantity" :label-width="formLabelWidth">
                  <el-input-number
                    size="small"
                    v-model="pack.quantity"
                    :min="0"
                    @change="$forceUpdate()"
                  ></el-input-number>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-form-item
                  label="Prix unitaire: "
                  :label-width="formLabelWidth"
                >
                  {{ pack.priceunit }} €
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-form-item label="Prix : " :label-width="formLabelWidth">
                  {{ pack.price }} €
                </el-form-item>
              </el-col>

              <el-col :span="1">
                <el-button
                  @click="removePackaging(index)"
                  type="danger"
                  :icon="ElIconDelete"
                  circle
                >
                </el-button>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row style="text-align: left">
          <el-col :span="4">
            <label>Ajouter Packaging : </label>
          </el-col>
          <el-col :span="4">
            <el-select
              v-model="newPackage"
              placeholder="Choisissez un emballage"
              filterable
              size="small"
            >
              <el-option
                v-for="(_source, index) in this.packagings"
                :key="index"
                :value="[
                  _source['CODE'],
                  _source['Label'],
                  _source['cout_prod'],
                ]"
                :label="_source['CODE'] + ' ' + _source['Label']"
              ></el-option>
            </el-select>
          </el-col>
          <el-col :span="3">
            <label>Quantité : </label>
          </el-col>
          <el-col :span="3">
            <el-input-number
              size="small"
              v-model="newPackageQuantity"
              :min="0"
              :model-value="1"
            ></el-input-number>
          </el-col>
          <el-col :span="4">
            <el-button
              type="primary"
              @click="addPackaging()"
              :icon="ElIconPlus"
              circle
            ></el-button>
          </el-col>
        </el-row>
      </el-card>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="$emit('dialogclose')">{{
        this.$t('buttons.cancel')
      }}</el-button>
      <el-button
        v-if="$store.getters.creds.hasPrivilege(config.config.writeprivileges)"
        type="primary"
        @click="saveRecord()"
        >{{ this.$t('buttons.confirm') }}</el-button
      >
    </span>
  </el-dialog>
</template>

<script>
import { Delete as ElIconDelete, Plus as ElIconPlus } from '@element-plus/icons'
import Vue from 'vue'

import YAML from 'js-yaml'
import axios from 'axios'

export default {
  data() {
    return {
      ElIconDelete,
      ElIconPlus,
    }
  },
  name: 'recetteEditor',
  data: () => ({
    orgRec: null,
    newRec: null,
    strOrgRec: '',
    strNewRec: '',
    orgName: '',
    newName: '',
    formLabelWidth: '120px',
    formLabelWidth2: '150px',
    changed: false,
    dialogFormVisible: false,
    title: 'Recette',
    allIngredients: null,
    newIngredient: null,
    newIngredientQuantity: 1,
    allProduits: null,
    newProduit: null,
    newProduitQuantity: 1,
    finalProducts: null,
    finalProduct: '',
    packagings: null,
    newPackage: null,
    newPackageQuantity: 0,
    prixUnitProduct: 0,
    prixUnitProductHTVA: 0,
    codeProduct: '',
    labelProduct: '',
  }),
  computed: {
    recordin: function () {
      return this.record
    },
    recordstr: function () {
      return JSON.stringify(this.record)
    },
    recchanged: function () {
      return JSON.stringify(this.recordin) != JSON.stringify(this.newRec)
    },

    totalPriceUnit: function () {
      var price = 0
      var qty = 0
      var packagePrice = 0

      for (var ingredient in this.newRec._source.ingredients) {
        console.log(ingredient)
        price += this.newRec._source.ingredients[ingredient]['price']
        qty += this.newRec._source.ingredients[ingredient]['quantity']
      }

      for (var produit in this.newRec._source.produits) {
        console.log(produit)
        price += this.newRec._source.produits[produit]['price']
        qty += this.newRec._source.produits[produit]['quantity']
      }

      for (var pack in this.newRec._source.packaging) {
        packagePrice += this.newRec._source.packaging[pack]['price']
      }

      if (qty == 0) {
        qty = 1
      }

      return parseFloat((price + packagePrice).toFixed(2))
    },

    totalPrice: function () {
      var price = 0
      var qty = 0

      for (var ingredient in this.newRec._source.ingredients) {
        console.log(ingredient)
        price += this.newRec._source.ingredients[ingredient]['price']
        qty += this.newRec._source.ingredients[ingredient]['quantity']
      }

      for (var produit in this.newRec._source.produits) {
        console.log(produit)
        price += this.newRec._source.produits[produit]['price']
        qty += this.newRec._source.produits[produit]['quantity']
      }

      if (qty == 0) {
        qty = 1
      }

      return parseFloat((price / qty).toFixed(2))
    },
  },
  props: {
    record: {
      type: Object,
    },
    config: {
      type: Object,
    },
    editMode: {
      type: String,
    },
  },
  watch: {
    recordin: {
      handler: function () {
        this.prepareData()
      },
      deep: true,
    },
  },
  created: function () {
    console.log('created event')
    this.prepareData()
  },
  components: {},
  methods: {
    closeDialog: function () {
      this.$emit('dialogclose')
    },
    removeIngredient: function (index) {
      console.log('coucou')
      console.log(this.newRec._source.ingredients[index])
      //delete this.newRec._source.ingredients[index]
      this.newRec._source.ingredients.splice(index, 1)
    },
    removeProduit: function (index) {
      console.log('coucou')
      console.log(this.newRec._source.produits[index])
      //delete this.newRec._source.ingredients[index]
      this.newRec._source.produits.splice(index, 1)
    },
    removePackaging: function (index) {
      console.log('coucou')
      console.log(this.newRec._source.packaging[index])
      //delete this.newRec._source.ingredients[index]
      this.newRec._source.packaging.splice(index, 1)
    },
    changeProduct: function () {
      this.codeProduct = this.finalProduct[0]
      this.labelProduct = this.finalProduct[1]
      this.prixUnitProduct = this.finalProduct[2]
      this.prixUnitProductHTVA = this.finalProduct[3]
    },
    prepareData: function () {
      console.log('prepare data')
      this.dialogFormVisible = true
      if (!this.record._source.ingredients) {
        console.log('New record')
        this.record._source.ingredients = []
        console.log(this.record)
      }

      if (!this.record._source.produits) {
        console.log('New record')
        this.record._source.produits = []
        console.log(this.record)
      }

      if (!this.record._source.packaging) {
        console.log('New record')
        this.record._source.packaging = []
        console.log(this.record)
      }

      this.newRec = JSON.parse(JSON.stringify(this.record))
      this.orgRec = JSON.parse(JSON.stringify(this.record))
      this.allIngredients = this.getIngredients()
      this.allProduits = this.getProduits()
      if (this.editMode != 'create') {
        this.finalProduct = [
          this.newRec._source['CODE'],
          this.newRec._source['Label'],
          this.newRec._source['Prix_TVAC'],
          this.newRec._source['HTVA'],
        ]
        console.log(this.finalProduct)
        this.prixUnitProduct = this.newRec._source['Prix_TVAC']
        this.prixUnitProductHTVA = this.newRec._source['HTVA']
        this.labelProduct = this.newRec._source['Label']
        this.codeProduct = this.newRec._source['CODE']
      }

      this.getCodes()
      this.getPackagings()

      if (this.editMode != 'create') {
        this.finalProduct = [
          this.newRec._source['CODE'],
          this.newRec._source['Label'],
          this.newRec._source['Prix_TVAC'],
          this.newRec._source['HTVA'],
        ]
        console.log(this.finalProduct)
      }

      this.$forceUpdate()
    },
    addIngredient: function () {
      var ingredientToAdd = {
        code: this.newIngredient[0],
        name: this.newIngredient[1],
        quantity: this.newIngredientQuantity,
        pricekg: this.newIngredient[2],
        price: parseFloat(
          (this.newIngredient[2] * this.newIngredientQuantity).toFixed(4)
        ),
      }
      this.newRec._source.ingredients.push(ingredientToAdd)
    },
    addProduit: function () {
      var produitToAdd = {
        code: this.newProduit[0],
        name: this.newProduit[1],
        quantity: this.newProduitQuantity,
        pricekg: this.newProduit[2],
        price: parseFloat(
          (this.newProduit[2] * this.newProduitQuantity).toFixed(4)
        ),
      }
      this.newRec._source.produits.push(produitToAdd)
    },
    addPackaging: function () {
      var packagingToAdd = {
        code: this.newPackage[0],
        name: this.newPackage[1],
        quantity: this.newPackageQuantity,
        priceunit: this.newPackage[2],
        price: parseFloat(
          (this.newPackage[2] * this.newPackageQuantity).toFixed(4)
        ),
      }
      this.newRec._source.packaging.push(packagingToAdd)
    },
    getIngredients: function () {
      var url =
        this.$store.getters.apiurl +
        'generic_search/schamp_ingredients' +
        '?token=' +
        this.$store.getters.creds.token

      var query = {
        size: 10000,
      }

      axios
        .post(url, query)
        .then((response) => {
          if (response.data.error != '') {
            console.log('fail to retrieve ingredients')
          } else {
            console.log(response)

            this.allIngredients = response.data.records
          }
        })
        .catch((error) => {
          console.log(error)
        })
    },

    getProduits: function () {
      var url =
        this.$store.getters.apiurl +
        'generic_search/schamp_pre_recettes' +
        '?token=' +
        this.$store.getters.creds.token

      var query = {
        size: 10000,
      }

      axios
        .post(url, query)
        .then((response) => {
          if (response.data.error != '') {
            console.log('fail to retrieve products')
          } else {
            console.log(response)

            this.allProduits = response.data.records
          }
        })
        .catch((error) => {
          console.log(error)
        })
    },
    getCodes: function () {
      var url =
        this.$store.getters.apiurl +
        'lambdas/8/get_products_list_light?apikey=' +
        this.$store.getters.creds.token

      var query = {
        size: 10000,
      }

      axios
        .post(url, query)
        .then((response) => {
          if (response.data.error != '') {
            console.log('fail to retrieve products')
          } else {
            console.log(response)

            this.finalProducts = response.data.products
          }
        })
        .catch((error) => {
          console.log(error)
        })
    },
    getPackagings: function () {
      var url =
        this.$store.getters.apiurl +
        'lambdas/8/get_packaging?apikey=' +
        this.$store.getters.creds.token

      var query = {
        size: 10000,
      }

      axios
        .post(url, query)
        .then((response) => {
          if (response.data.error != '') {
            console.log('fail to retrieve products')
          } else {
            console.log(response)

            this.packagings = response.data.products
          }
        })
        .catch((error) => {
          console.log(error)
        })
    },

    saveRecord: function () {
      this.newRec._source.modifyBy = this.$store.getters.creds.user.login
      this.newRec._source.orderDate = Date.now()
      this.newRec._source.price = this.totalPrice
      this.newRec._source.CODE = this.finalProduct[0]
      this.newRec._source.Label = this.finalProduct[1]
      this.newRec._source.Prix_TVAC = this.finalProduct[2]
      this.newRec._source.HTVA = this.finalProduct[3]
      this.newRec._source.priceUnit = this.totalPriceUnit
      this.newRec._source.marge = this.finalProduct[3] - this.totalPriceUnit

      this.$store.commit({
        type: 'updateRecord',
        data: this.newRec,
      })
      this.$notify({
        title: 'Record saved.',
        type: 'success',
        message: 'Le produit a été enregistrée.',
        position: 'bottom-right',
      })
      this.$emit('dialogcloseupdated')
    },
  },
}
</script>

<style>
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
