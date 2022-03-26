const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    "./src/hkssprangers/**/*.hx",
  ],
  theme: {
    extend: {
      colors: {
        green: colors.emerald,
        yellow: colors.amber,
        purple: colors.violet,
      }
    },
  },
  plugins: [],
}
