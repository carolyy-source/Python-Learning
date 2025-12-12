<script setup>
import Header from "../components/Header.vue";
import HeroSearch from "../components/HeroSearch.vue";
import FeaturedDestinations from "../components/FeaturedDestinations.vue";
import Footer from "../components/Footer.vue";
</script>

<template>
  <div class="min-h-screen bg-page-bg">
    <Header />
    <main>
      <HeroSearch />
      <FeaturedDestinations />
    </main>
    <Footer />
  </div>
</template>
