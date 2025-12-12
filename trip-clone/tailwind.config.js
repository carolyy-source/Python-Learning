/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: "#93ACAA", // Main button color
        "primary-hover": "#6D8FA3", // Button hover color
        secondary: "#2F3D4D", // Dark theme color (Footer)
        accent: "#6D8FA3", // Secondary theme color
        "page-bg": "#DBD0BE", // Global background
        title: "#000000", // Title color
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
      },
    },
  },
  plugins: [],
};
