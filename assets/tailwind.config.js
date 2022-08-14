const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {},
    fontFamily: {
      // https://www.youtube.com/watch?v=sOnBG2wUm1s
      mono: ["DM Mono", ...defaultTheme.fontFamily.mono],
      sans: ["Poppins", ...defaultTheme.fontFamily.sans],
      serif: ["Lora", ...defaultTheme.fontFamily.serif],
    },
  },
  plugins: [require("@tailwindcss/forms"), require("@tailwindcss/typography")],
};
