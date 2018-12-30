const presets = [
  [
    '@babel/env',
    {
      targets: {
        chrome: '70',
      },
      useBuiltIns: 'entry',
    },

  ],
];

// sourceType: scriptにしないと、babelが グローバルの this を void 0 に変えてしまう
const overrides = [{
  test: /elm\/.*\.js$/,
  sourceType: 'script',
}];
module.exports = { presets, overrides };
