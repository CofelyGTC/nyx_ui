module.exports = {
  root: true,
  env: {
    node: true
  },
  'extends': [
    'plugin:vue/essential',
    'eslint:recommended'
  ],
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    "vue/multi-word-component-names": 'off',
    "no-unused-vars": "off",
    "no-useless-escape" : "off",
    "vue/no-unused-components" : "off"
  },
  parserOptions: {
    parser: "@babel/eslint-parser",
  }
}
